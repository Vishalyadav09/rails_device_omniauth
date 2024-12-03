class AddLastSignInToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_sign_in, :jsonb, default: {}
  end
end
