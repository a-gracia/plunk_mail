module PlunkMail
  class DeliveryMethod
    def initialize(settings = {})
      @api_key = settings[:api_key]
    end

    def deliver!(mail)
      Faraday.post(
        "https://next-api.useplunk.com/v1/send",
        {
          to: mail.to.first,
          subject: mail.subject,
          body: email_body(mail)
        }.to_json,
        {
          "Authorization" => "Bearer #{@api_key}",
          "Content-Type" => "application/json"
        }
      )
    end

    private

    def email_body(mail)
      mail.html_part&.body&.decoded || mail.body.decoded
    end
  end
end