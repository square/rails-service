# Microservices on Rails

Rails::Service is an opinionated Rails Engine providing boiler plate needed for
making microservice Rails application.

## Note on Microservices

Microservices architecture is a great way to build and scale huge distributed
applications. It implies though that it's not for everybody and you're probably better
off sticking with your monolith and considering microservices in the future when
the need arise or even maybe never if you'll lucky.

Microservices are not for everybody, they're hard and in fact they're not a good
solution for everybody.

Before choosing and investing in microservices architecture, I advise you to
strongly considering it from every angle.

Recommended reads/videos:

  * [Microservices](http://martinfowler.com/articles/microservices.html) by Martin Fowler
  * [RailsConf 2015 Keynote](https://www.youtube.com/watch?v=KJVTM7mE1Cc) by David Heinemeier Hansson (video)
  * [Ruby On Ales 2015 - The Recipe for the Worlds Largest Rails Monolith](https://www.youtube.com/watch?v=naTRzjHaIhE) by Akira Matsuda (video)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-service'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-service


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Any contributors to the master *rails-service* repository must sign the [Individual Contributor License Agreement (CLA)](https://spreadsheets.google.com/spreadsheet/viewform?formkey=dDViT2xzUHAwRkI3X3k5Z0lQM091OGc6MQ&ndplr=1). It's a short form that covers our bases and makes sure you're eligible to contribute.

When you have a change you'd like to see in the master repository, send a [pull request](https://github.com/square/rails-service/pulls). Before we merge your request, we'll make sure you're in the list of people who have signed a CLA.

## License

```
Copyright 2015 Square, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
