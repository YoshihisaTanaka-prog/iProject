# ActionMailer::Base.delivery_method = :letter_opener_web

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  domain: 'gmail.com',
  port: 587,
  user_name: ENV['GMAIL_ADDRESS'],
  password: ENV['GMAIL_PW'],
  authentication: 'plain',
  enable_starttls_auto: true
}