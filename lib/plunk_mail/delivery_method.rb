module PlunkMail
  class DeliveryMethod
    def initialize(settings = {})
      @api_key = settings[:api_key]
    end

    def deliver!(mail)
      response = Faraday.post(
        "https://next-api.useplunk.com/v1/send",
        {
          to: mail.to.first,
          subject: mail.subject,
          body: email_body(mail),
          from: {
            name: mail[:from]&.display_names&.first,
            email: mail.from.first
          }.compact
        }.to_json,
        {
          "Authorization" => "Bearer #{@api_key}",
          "Content-Type" => "application/json"
        }
      )

      raise "Plunk error: #{response.status} #{response.body}" unless response.success?

      response
    end

    private

    def email_body(mail)
      mail.html_part&.body&.decoded || mail.body.decoded
    end
  end
end