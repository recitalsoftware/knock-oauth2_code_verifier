module Knock
  module Oauth2CodeVerifier
    class Engine < ::Rails::Engine
      isolate_namespace Knock::Oauth2CodeVerifier
    end
  end
end
