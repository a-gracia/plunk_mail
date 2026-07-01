# PlunkMail

ActionMailer delivery method for sending emails through Plunk.

PlunkMail allows Rails applications to use Plunk as an ActionMailer delivery method:

```ruby
config.action_mailer.delivery_method = :plunk
```

## Usage

Configure Plunk in your `config/environments/production.rb`:

```ruby
config.action_mailer.delivery_method = :plunk

config.action_mailer.plunk_settings = {
  api_key: ENV["PLUNK_API_KEY"]
}
```

Use ActionMailer normally:

```ruby
class UserMailer < ApplicationMailer
  def welcome(user)
    mail(
      to: user.email,
      subject: "Welcome"
    )
  end
end
```

Send the email:

```ruby
UserMailer.welcome(user).deliver_now
```

HTML emails are supported automatically. If an HTML part exists, it will be sent through Plunk.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "plunk_mail"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install plunk_mail
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
