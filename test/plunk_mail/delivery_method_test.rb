require "test_helper"
require "webmock/minitest"
require "faraday"

class PlunkMail::DeliveryMethodTest < ActiveSupport::TestCase
  setup do
    @delivery = PlunkMail::DeliveryMethod.new(
      api_key: "test_key"
    )
  end

  test "sends email to Plunk" do
    stub_request(
      :post,
      "https://next-api.useplunk.com/v1/send"
    ).with(
      headers: {
        "Authorization" => "Bearer test_key",
        "Content-Type" => "application/json"
      }
    ).to_return(status: 200)

    mail = Mail.new do
      to "user@example.com"
      subject "Hello"
      body "Test body"
    end

    response = @delivery.deliver!(mail)

    assert_equal 200, response.status
  end


  test "uses html body when email has html part" do
    stub_request(
      :post,
      "https://next-api.useplunk.com/v1/send"
    ).with do |request|
      body = JSON.parse(request.body)

      assert_equal "user@example.com", body["to"]
      assert_equal "Hello", body["subject"]
      assert_equal "<h1>Hello</h1>", body["body"]
    end.to_return(status: 200)

    mail = Mail.new do
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

    @delivery.deliver!(mail)
  end
end