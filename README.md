# Backend provider of code verification for Oauth2 Authorization Code Request

Frontend libraries implement Oauth2 flows that authenticate the user with your
SPA, but are only part of the picture. If you're storing user data on a backend,
you'll need to authenticate them on both the frontend and the backend. That's
what Oauth2   Authorization Code Request does, with PKCE thrown in for added
security. This gem provides the backend authorization needed, taking in a
verification request and logging the user in via JWT with Knock. If you're using
Vue/React/etc with a frontend authorization library like @nuxt/auth, and you're
running Rails in API mode for your backend, this gem completes the picture.

Suggestions for improvement, bugs, and PRs are very welcomed.

## Requirements

[knock](https://github.com/nsarno/knock) for JWT authentication 

I'd be happy to split this into an independent gem if you want to use it for
another auth library; file an issue with that request if you want (matching
PR preferred, of course).

**Note: if you're using Rails 6, you may have to use the master branch:**

```ruby
# Gemfile
# See https://davidgay.org/programming/jwt-auth-rails-6-knock/
# and https://github.com/nsarno/knock/issues/250
gem "knock", github: "nsarno/knock", branch: "master",
             ref: "9214cd027422df8dc31eb67c60032fbbf8fc100b"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'knock-oauth2_code_verifier'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install knock-oauth2_code_verifier

## Usage

Set up the routes and controller:

```ruby
# config/routes.rb
post "auth_token/:provider", to: "auth_token#create"
```

And create the controller:

```ruby
# app/controllers/auth_token_controller.rb
class AuthTokenController < Knock::Oauth2CodeVerifier::AuthTokenController
  def create
    # knock-oauth2_code_verifier exposes:
    # access_token - the user's access token for the provider
    # refresh_token - the user's refresh_token, when first registering (blank on
    #   login)
    # user_info - hash of user's info, with keys :name, :email, and :raw
    #   :raw contains the raw info hash from the provider

    # Your code to create and login user here
    # e.g. user = User.find_or_create_by!(user_info[:email])

    # Then return a JWT payload; auth_token provided by Knock
    render json: { token: auth_token }, status: :created
  end
end
```

And finally configure the gem (use providers as necessary; Google Oauth2 and
Microsoft Azure Active Directory [NOT the B2C flavour] shown as examples):

```ruby
# config/initializers/knock_oauth2_code_verifier.rb
Knock::Oauth2CodeVerifier.configure do |config|
  # The first argument, provder name, is inferred from the request URL:
  # e.g. POST /auth_token/google
  config.add_provider(
    :google,
    Rails.application.credentials.google_app[:client_id],
    Rails.application.credentials.google_app[:client_secret],
    {
      token_url: "https://accounts.google.com/o/oauth2/token",
      userinfo_url: "https://www.googleapis.com/oauth2/v3/userinfo"
    }
  )

  config.add_provider(
    :microsoft365,
    Rails.application.credentials.microsoft_app[:client_id],
    Rails.application.credentials.microsoft_app[:client_secret],
    {
      token_url: "https://login.microsoftonline.com/common/oauth2/v2.0/token",
      userinfo_url: "https://graph.microsoft.com/v1.0/me"
    }
  )
end
```

Then you can set your client library to forward code challenges to POST
`/auth_token/:provider`, e.g. `/auth_token/microsoft365`. For @nuxt/auth, that
looks like:

```javascript
# nuxt.config.js
export default {
  auth: {
    strategies: {
      google: {
        endpoints: {
          token: 'http://localhost:4000/auth_token/google'
        }
      }
    }
  }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/recitalsoftware/knock-oauth2_code_verifier. This project is
intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the
[code of conduct](https://github.com/recitalsoftware/knock-oauth2_code_verifier/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Knock::Oauth2CodeVerifier project's codebases, issue
trackers, chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/recitalsoftware/knock-oauth2_code_verifier/blob/master/CODE_OF_CONDUCT.md).
