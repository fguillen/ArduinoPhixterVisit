class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :phixters
  validates_confirmation_of :email
end
