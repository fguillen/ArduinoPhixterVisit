class Notifier < ActionMailer::Base
  default_url_options[:host] = "phixtervisits.fernandoguillen.info"

  def password_reset_instructions(user, sent_at = Time.now)
    subject    'PhixterVisits: Password Reset Instructions'
    recipients user.email
    from       'Fernando Guillen aka PhixterVisits admin <fguillen.mail@gmail.com>'
    sent_on    sent_at
    
    body       :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

end
