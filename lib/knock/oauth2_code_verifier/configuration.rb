# frozen_string_literal: true



module Knock
  module Oauth2CodeVerifier
    class Configuration
      attr_accessor :providers

      def initialize
        @providers = {}
      end

      def add_provider(provider, client_id, client_secret, urls)
        raise "provider is required" unless provider
        raise "client ID for provider is required" unless client_id
        raise "client secret for provider is required" unless client_secret
        raise "URL for token is required" unless urls[:token_url]
        raise "URL for user info is required" unless urls[:userinfo_url]

        @providers[provider] = {
          client_id: client_id,
          client_secret: client_secret,
          token_url: urls[:token_url],
          userinfo_url: urls[:userinfo_url],
        }
      end

      def for_provider(provider)
        OpenStruct.new(@providers[provider.to_sym])
      end
    end
  end
end
