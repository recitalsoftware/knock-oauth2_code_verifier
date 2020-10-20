# frozen_string_literal: true

require_relative "lib/knock/oauth2_code_verifier/version"

Gem::Specification.new do |spec|
  spec.name          = "knock-oauth2_code_verifier"
  spec.version       = Knock::Oauth2CodeVerifier::VERSION
  spec.authors       = ["Brendan Mulholland"]
  spec.email         = ["brendan@recital.software"]

  spec.summary       = "Backend provider of code verification for Oauth2\
Authorization Code Request"
  spec.description   = "Frontend libraries implement Oauth2 flows that \
authenticate the user with your SPA, but are only part of the picture. If you're\
storing user data on a backend, you'll need to authenticate them on both the\
frontend and the backend. That's what Oauth2 Authorization Code Request does,\
with PKCE thrown in for added security. This gem provides the backend\
authorization needed, taking in a verification request and logging the user in\
via JWT with Knock. If you're using Vue/React/etc with a frontend authorization\
library like @nuxt/auth, and you're running Rails in API mode for your backend,\
this gem completes the picture."
  spec.homepage      = "https://github.com/recitalsoftware/knock-oauth2_code_verifier"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f|
      f.match(%r{^(test|spec|features)/})
    }
  end
  spec.require_paths = %w[app lib]

  spec.add_dependency "rails", ">= 5"
  spec.add_dependency "knock", ">= 2.1.0"
  spec.add_dependency "oauth2", ">= 1.4.0"
end
