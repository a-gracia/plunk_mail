require "test_helper"
require "webmock/minitest"
require "faraday"
require "json"

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
    ).with do |request|
      assert_equal "Bearer test_key", request.headers["Authorization"]
      assert_equal "application/json", request.headers["Content-Type"]

      body = JSON.parse(request.body)

      assert_equal "user@example.com", body["to"]
      assert_equal "Hello", body["subject"]
      assert_equal "Test body", body["body"]

      assert_equal(
        {
          "email" => "sender@example.com"
        },
        body["from"]
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

      assert_equal(
        {
          "name" => "Rischio",
          "email" => "hello@example.com"
        },
        body["from"]
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

    response = @delivery.deliver!(mail)

    assert_equal 200, response.status
  end
end