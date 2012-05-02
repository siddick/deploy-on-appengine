# Deploy::On::Appengine

To support latest bundler on appengine.

## Installation

Install gem and jruby:

    $ gem install deploy-on-appengine [ not yet published ]
    $ rvm install jruby

## Usage

Create rails application:

    $ rails new https://raw.github.com/siddick/deploy-on-appengine/master/templates/rails3.rb --old-style-hash
    $ rails g scaffold posts title:string content:text
    $ rake db:migrate
    $ rails s

Support existing

    $ cd project
    $ deploy-on-appengine-setup

To test on appengine enviornment and deploy:

    $ dev_appserver --port=3000 . --jvm_flag=-Dappengine.user.timezone=UTC
    $ appcfg update .

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
