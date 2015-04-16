# SpreeMatkahuolto

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'spree_matkahuolto'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spree_matkahuolto

Then, to copy and execute the migrations, run:
 
    $ rails g spree_matkahuolto:install

Then, add this requirement in your application.js.coffee 

    #= require shipping_method_matkahuolto

And add this requirement to your application.scss
  
    *= require shipping_method_matkahuolto

## Usage

Give access to for Rails your Matkahuolto credentials (username, password and test_mode) as environment variables:
    
    ENV["#{Rails.env.upcase}_MATKAHUOLTO_USERNAME"]
    
    ENV["#{Rails.env.upcase}_MATKAHUOLTO_PASSWORD"]
    
    ENV["#{Rails.env.upcase}_MATKAHUOLTO_TEST_MODE"]

In the Spree backend, shipping methods which internal names contains the following will be automatically linked to Matkahuolto backend:

    matkahuolto_lahella

    matkahuolto_jako

In the Spree checkout process, on the delivery method selection page, Matkahuolto Lahella will display a selection of available pickup places

In the Spree backend, any order that used Matkahuolto Lahella or Matkahuolto Jako as a delivery method will now provide a "print labels" link enabling to automatically download the package label PDF generated by Matkahuolto.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/spree_matkahuolto/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
