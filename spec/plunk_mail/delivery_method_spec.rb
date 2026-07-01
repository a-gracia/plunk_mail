require "webmock/rspec"
require "faraday"
require "json"
require "plunk_mail"

describe PlunkMail::DeliveryMethod do
  let(:delivery) do
    described_class.new(
      api_key: "test_key"
    )
  end

  it "sends email to Plunk" do
    stub_request(
      :post,
      "https://next-api.useplunk.com/v1/send"
    ).with do |request|
      expect(request.headers["Authorization"]).to eq("Bearer test_key")
      expect(request.headers["Content-Type"]).to eq("application/json")

      body = JSON.parse(request.body)

      expect(body["to"]).to eq("user@example.com")
      expect(body["subject"]).to eq("Hello")
      expect(body["body"]).to eq("Test body")

      expect(body["from"]).to eq(
        {
          "email" => "sender@example.com"
        }
      )
    end.to_return(
      status: 200,
      body: "{}"
    )

    mail = Mail.new do
      from "sender@example.com"
      to "user@example.com"
      subject "Hello"
      body "Test body"
    end

    response = delivery.deliver!(mail)

    expect(response.status).to eq(200)
  end

  it "uses html body when email has html part" do
    stub_request(
      :post,
      "https://next-api.useplunk.com/v1/send"
    ).with do |request|
      body = JSON.parse(request.body)

      expect(body["to"]).to eq("user@example.com")
      expect(body["subject"]).to eq("Hello")
      expect(body["body"]).to eq("<h1>Hello</h1>")

      expect(body["from"]).to eq(
        {
          "name" => "Rischio",
          "email" => "hello@example.com"
        }
      )
    end.to_return(
      status: 200,
      body: "{}"
    )

    mail = Mail.new do
      from "Rischio <hello@example.com>"
      to "user@example.com"
      subject "Hello"

      text_part do
        body "Plain text"
      end

      html_part do
        content_type "text/html"
        body "<h1>Hello</h1>"
      end
    end

    response = delivery.deliver!(mail)

    expect(response.status).to eq(200)
  end
end