class Tweet < ActiveRecord::Base
  validates_presence_of :content, :message
  belongs_to :user
end
