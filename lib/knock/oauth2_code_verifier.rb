# frozen_string_literal: true

require "knock/oauth2_code_verifier/version"
require "knock/oauth2_code_verifier/configuration"

module Knock
  module Oauth2CodeVerifier
    class Error < StandardError; end

    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
