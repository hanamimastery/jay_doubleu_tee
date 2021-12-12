# JayDoubleuTee

A JWT authorization middleware for any web application.

JayDoubleuTee is inspired by [Hanami philosophy](https://hanamirb.org) to build components that are highly reusable, and compatible with any ruby application.

JayDoubleuTee is fully compatible with RACK, so it is with Hanami, Rails, Sinatra, Roda, and whatever else you can think about.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jay_doubleu_tee'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jay_doubleu_tee

## Usage

`jay_double_uti` uses RS256 algorithm by default, so youl'll need a private/public key pair and the access token for testing it out.

In your console run

```ruby
require 'jwt'
payload = {
  data: { user_id: "de804507-5d03-4493-a038-d62f499b8a96" }, scopes: ""
}
private_key = OpenSSL::PKey::RSA.generate 2048
secret = private_key.public_key.to_s
token = JWT.encode payload, private_key, 'RS256'
```

Then save the `ENV` variable `JAY_DOUBLEU_TEE_PUBLIC_KEY` by setting the as a value your secret.

### Plain ruby Rack application

```ruby
require "jay_doubleu_tee"

class App
  include JayDoubleuTee::Auth

  def call(env)
    status, body =
      if auth.success?
        [200, [{ message: "Hello, World!", auth: auth.value! }]]
      else
        [401, [{ error: auth.failure }.to_json]]
      end

    [status, headers, body]
  end

  private

  def headers
    { 'Content-Type' => 'application/json' }
  end
end

use JayDoubleuTee::Authentication

run App.new
```

```shell
curl --location --request GET 'http://localhost:9292' \
--header 'Authorization: Bearer <<YOUR_TOKEN>>'

# => 200:
  # {
  #   message: 'Hello, World!,
  #   auth: {
  #     data: { user_id: "de804507-5d03-4493-a038-d62f499b8a96" },
  #     scopes: ""
  #   }
  # }
```

```shell
curl --location --request GET 'http://localhost:9292' \
--header 'Authorization: Bearer invalid'

# => 401: { error: Unauthorized. Token invalid }
```

### Hanami 2.0

```ruby
# config.ru

require "jay_doubleu_tee"
use JayDoubleuTee::Authentication
```

### Rails

```ruby
# config.ru

require "jay_doubleu_tee"
use JayDoubleuTee::Authentication
```

#### Supported algorithms

JayDoubleuTee users RS256 encryption algoritym by default, but you can completely disable the token signature validation by setting up algorithm to 'none'. Check out the Configuration section.

Below are listed all supported algoritms at the moment.

```ruby
%w[none HS256 RS256 prime256v1 ES256 ED25519 PS256]
```

For more info about each of them refer to [jwt documentation](https://github.com/jwt/ruby-jwt#algorithms-and-usage)

### Configuration

To set encryption algorithm, you can configure several fields

```ruby
JayDoubleuTee.configure do |config|
  config.algorithm = 'RS256'
  config.secret = ENV['PUBLIC_KEY']
end
```

Again, for information how to generate private and public keys, [jwt documentation](https://github.com/jwt/ruby-jwt#algorithms-and-usage) or check out the [spec files](https://github.com/hanamimastery/jay_doubleu_tee/tree/master/spec/jay_doubleu_tee/decoder_spec.rb)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Resources

It's built on top of several gems to ensure the best user experience.

- [JWT](https://github.com/jwt/ruby-jwt#algorithms-and-usage)
- [dry-effects](https://dry-rb.org/gems/dry-effects). Here is the [video tutorial for dry-effects](https://hanamimastery.com/episodes/11-effective-ruby-programming-with-dry-effects)
- [dry-monads](https://dry-rb.org/gems/dry-monads). Here is a [video tutorial for dry-monads](https://hanamimastery.com/episodes/7-untangle-your-app-with-dry-monads)
- [dry-configurable](https://dry-rb.org/gems/dry-configurable). Here is the [video tutorial for dry-configurable](https://hanamimastery.com/episodes/5-configure-anything-with-dry-configurable)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hanamimastery/jay_doubleu_tee. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hanamimastery/jay_doubleu_tee/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JayDoubleuTee project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/jay_doubleu_tee/blob/master/CODE_OF_CONDUCT.md).
