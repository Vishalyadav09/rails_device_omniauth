class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2 github]


  def self.from_omniauth(auth)
    name_split = auth.info.name.split(" ") rescue ["", ""]
    user = User.find_by(email: auth.info.email) if auth.info.email.present?
    
    if user.nil? && auth.info.email.blank?
      user = User.find_by(uid: auth.uid, provider: auth.provider) 
    end

    if user.nil?
      user = User.create(
        email: auth.info.email.presence || "#{auth.uid}@#{auth.provider}.com",
        provider: auth.provider,
        uid: auth.uid,
        first_name: name_split[0],
        last_name: name_split[1],
        password: Devise.friendly_token[0, 20]
      )
    end

    user.add_last_sign_in(auth)  

    user
  end

  def add_last_sign_in(auth)
    last_sign_in_detail = {
      provider: auth.provider,
      uid: auth.uid,
      sign_in_at: Time.current
    }

    update_column(:last_sign_in, last_sign_in_detail)
  end

end
