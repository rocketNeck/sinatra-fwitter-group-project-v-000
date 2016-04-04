class User < ActiveRecord::Base
  validates_presence_of :username, :email, :password
  has_many :tweets
  ######### has_secure_password is not working
  ######### used password_digest and require  and all else explained in the labs
  ######### a learn TA stated that this lab could not allow password_digest in the schema
  ######### after we went through and built the models togeather 
  def slug
    self.username.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
    self.all.find{|i| i.slug == slug}
  end
end
