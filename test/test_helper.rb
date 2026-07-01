ENV["RAILS_ENV"] = "test"

require "bundler/setup"
require "minitest/autorun"

require "active_support"
require "active_support/test_case"

require "plunk_mail"