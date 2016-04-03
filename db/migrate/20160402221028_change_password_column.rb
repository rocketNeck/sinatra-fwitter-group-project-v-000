class ChangePasswordColumn < ActiveRecord::Migration
  def change
    rename_column :users, :password_digest, :password
  end
end
