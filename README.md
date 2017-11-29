# Newgistics::Api

A Ruby 2 client for the Newgistics API, free from dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'newgistics-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install newgistics-api

## Usage

1. Initialize the GEM:
```ruby
NewgisticsApi.configure do |config|
  config.api_key = api_credentials["api_key"]
  config.host = api_credentials["host"]
end
```

2. Run a request
Each of the method arguments are passes as keyword arguments. You can find the supported methods in lib/newgistics_api.

For example, the tracking API takes 3 parameters: `def track_shipment(merchant_id: nil, qualifier: nil, search_strings: [])`:
```ruby
response = NewgisticsApi::Tracking.new.track_shipment(merchant_id: "123", qualifier: "Barcode", search_strings: [721234567890])
```

3. Manipulate the response
```ruby
response.success?

response.body # raw JSON body
response.parsed_body # JSON parsed body
response.decorated_response # decorated response if the class has a decorator
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

If you need to re-run VCR cassettes, `cp spec/api_credentials.yml.sample spec/api_credentials.yml` and update the file with your credentials. VCR is configured to anonymize the API_KEY and the HOST for you.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thredup/newgistics-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Before pushing your changes, make sure you worked on the test coverage and your test files and VCR cassettes don't contain any credentials or any kind of critical information.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Newgistics::Api project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/thredup/newgistics-api/blob/master/CODE_OF_CONDUCT.md).
