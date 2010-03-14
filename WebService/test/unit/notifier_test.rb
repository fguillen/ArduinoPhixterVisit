require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  def test_password_reset_instructions
    user = Factory(:user)
    user.expects( :perishable_token ).returns( 'wadus_token' )
    
    @expected.subject     = 'PhixterVisits: Password Reset Instructions'
    @expected.body        = read_fixture('password_reset_instructions')
    @expected.from        = 'Fernando Guillen aka PhixterVisits admin <fguillen.mail@gmail.com>'
    @expected.date        = Time.now
    @expected.to          = user.email

    # puts Notifier.create_password_reset_instructions(user, @expected.date).body

    assert_equal @expected.encoded, Notifier.create_password_reset_instructions(user, @expected.date).encoded
  end

end
