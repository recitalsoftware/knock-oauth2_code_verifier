# frozen_string_literal: true

require "oauth2"

module Knock
  module Oauth2CodeVerifier
    class AuthTokenController < Knock::AuthTokenController
      # Knock provides a bunch of auth stuff for us, so we base on that
      # controller, but we don't want their default auth method (we need to auth
      # them via OAuth, not the default email/password check)
      skip_before_action :authenticate

      def create
        raise "Implement #create in your controller"
      end

      private

      def config
        Knock::Oauth2CodeVerifier.configuration.for_provider(params[:provider])
      end

      def client
        @client ||= OAuth2::Client.new(
          config.client_id,
          config.client_secret,
          authorize_url: config.authorize_url,
          token_url: config.token_url,
          logger: Rails.logger,
        )
      end

      def access_token
        @access_token ||= client
          .auth_code
          .get_token(
            params[:code],
            {
              redirect_uri: params[:redirect_uri],
              code_verifier: params[:code_verifier],
            },
          )
      end

      def refresh_token
        # Only set on the first auth, and perhaps if the access token expires?
        # e.g. https://developers.google.com/identity/protocols/oauth2#expiration
        access_token&.refresh_token
      end

      def user_info
        return @user_info if @user_info

        info = JSON.parse(access_token.get(config[:userinfo_url]).body)

        @user_info = {
          auth_provider: params[:provider],
          name: info["name"] || info["displayName"],
          email: info["email"] || info["mail"],
          refresh_token: refresh_token,
          raw_info: info,
        }
      end
    end
  end
end
