class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    handle_omniauth("Facebook")
  end

  def google_oauth2
    handle_omniauth("Google")
  end

  def github
    handle_omniauth("github")
  end

  def twitter
    handle_omniauth("twitter")
  end

  def linkedin
    handle_omniauth("linkedin")
  end
  
  def failure
    redirect_to root_path
  end

  private

  def handle_omniauth(provider_name)
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      session["devise.#{provider_name.downcase}_data"] = auth.except(:extra)
      redirect_to new_user_registration_url
    end
  end

end
