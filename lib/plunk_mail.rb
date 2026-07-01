require "plunk_mail/version"
require "plunk_mail/delivery_method"
require "action_mailer"

ActionMailer::Base.add_delivery_method(
  :plunk,
  PlunkMail::DeliveryMethod
)

module PlunkMail
end