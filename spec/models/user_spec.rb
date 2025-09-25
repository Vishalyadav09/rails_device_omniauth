require 'rails_helper'
require 'ostruct'

RSpec.describe User, type: :model do
  describe ".from_omniauth" do
    it "creates a new user if none exists" do
      auth = OpenStruct.new(
        provider: "facebook",
        uid: "12345",
        info: OpenStruct.new(name: "John Doe", email: "new@example.com")
      )

      expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
    end
  end

  describe "#add_last_sign_in" do
    it "updates last_sign_in with provider and uid" do
      user = User.create!(email: "foo@example.com", password: "password")
      auth = OpenStruct.new(
        provider: "facebook",
        uid: "12345",
        info: OpenStruct.new(name: "John Doe", email: "foo@example.com")
      )

      user.add_last_sign_in(auth)
      last_sign_in = user.reload.last_sign_in

      expect(last_sign_in[:provider]).to eq("facebook")
      expect(last_sign_in[:uid]).to eq("12345")
      expect(last_sign_in[:sign_in_at]).not_to be_nil
    end
  end
end
