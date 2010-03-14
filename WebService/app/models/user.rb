class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :phixters, :dependent => :destroy
  
  validates_confirmation_of :email
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end
end
