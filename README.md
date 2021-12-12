# JayDoubleUti

A JWT authorization middleware for any web application.

JayDoubleUti is inspired by [Hanami philosophy](https://hanamirb.org) to build components that are highly reusable, and compatible with any ruby application.

JayDoubleUti is fully compatible with RACK, so it is with Hanami, Rails, Sinatra, Roda, and whatever else you can think about.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jay_double_uti'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jay_double_uti

## Usage

require "jay_double_uti"

class App
  include JayDoubleUti::Auth

  def call(env)
    if auth.success?
      [
        200,
        { 'Content-Type' => 'application/json' },
        ["Hello, World!\n#{auth.value!}"]
      ]
    else
      [
        401,
        { 'Content-Type' => 'application/json' },
        [{ error: auth.failure }.to_json]
      ]
    end
  end
end


#### Supported algorithms

JayDoubleUti does not use any encryption algoritym by default. 'none' is set.

Below are listed all supported algoritms at the moment.

```ruby
%w[none HS256 RS256 prime256v1 ES256 ED25519 PS256]
```

For more info about each of them refer to [jwt documentation](https://github.com/jwt/ruby-jwt#algorithms-and-usage)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hanamimastery/jay_double_uti. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hanamimastery/jay_double_uti/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JayDoubleUti project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/jay_double_uti/blob/master/CODE_OF_CONDUCT.md).
