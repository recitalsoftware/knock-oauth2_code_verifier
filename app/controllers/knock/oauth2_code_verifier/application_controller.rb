module Knock
  module Oauth2CodeVerifier
    class ApplicationController < ActionController::Base
      protect_from_forgery with: :exception
    end
  end
end
