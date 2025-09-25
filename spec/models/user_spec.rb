# spec/models/user_spec.rb
require 'rails_helper'
require 'ostruct'

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    it 'creates a new user if none exists' do
      auth = OpenStruct.new(
        provider: "facebook",
        uid: "12345",
        info: OpenStruct.new(name: "John Doe", email: "new@example.com")
      )

      user = User.from_omniauth(auth)

      expect(user).to be_persisted
      expect(user.email).to eq("new@example.com")
      expect(user.provider).to eq("facebook")
      expect(user.uid).to eq("12345")
      expect(user.first_name).to eq("John")
      expect(user.last_name).to eq("Doe")
    end
  end

  describe '#add_last_sign_in' do
    it 'updates the last_sign_in column with provider, uid, and current time' do
      user = User.create!(email: "foo@example.com", password: "password123")
      auth = OpenStruct.new(
        provider: "facebook",
        uid: "12345",
        info: OpenStruct.new(name: "John Doe", email: "foo@example.com")
      )

      user.add_last_sign_in(auth)
      last_sign_in = user.reload.last_sign_in

      expect(last_sign_in["provider"]).to eq("facebook")
      expect(last_sign_in["uid"]).to eq("12345")
      expect(Time.parse(last_sign_in["sign_in_at"]).to_i).to be_within(5).of(Time.current.to_i)
    end
  end
end
