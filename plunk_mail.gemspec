require_relative "lib/plunk_mail/version"

Gem::Specification.new do |spec|
  spec.name        = "plunk_mail"
  spec.version     = PlunkMail::VERSION
  spec.authors     = [ "Andres Gracia Danies" ]
  spec.email       = [ "18741308+a-gracia@users.noreply.github.com" ]
  spec.homepage    = "https://github.com/a-gracia/plunk_mail"
  spec.summary     = "ActionMailer delivery method for sending emails through Plunk (https://www.useplunk.com/)."
  spec.description = "PlunkMail allows Rails applications to use Plunk (https://www.useplunk.com/) as an ActionMailer delivery method."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/a-gracia/plunk_mail"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_runtime_dependency "rails", "~> 8.1", ">= 8.1.3"
  spec.add_runtime_dependency "faraday", "~> 2.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.required_ruby_version = ">= 3.3.0"
end
