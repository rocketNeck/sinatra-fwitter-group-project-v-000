class User < ActiveRecord::Base
  validates_presence_of :username, :email, :password_digest
  has_many :tweets
end
