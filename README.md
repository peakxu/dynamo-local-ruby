# DynamoLocalRuby

Ruby wrapper around DynamoLocal to enable easier testing of your Ruby code that uses Dynamo.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynamo-local-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynamo-local-ruby

## Usage

In your application code, initialize Dynamo clients with

    Aws::DynamoDB::Client.new(endpoint: DynamoDBLocal::ENDPOINT)

Before the test suite starts

    DynamoDBLocal.up

When cleaning up test suite

    DynamoDBLocal.down

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dynamo-local-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
