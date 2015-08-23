# Bootscale

Speedup applications boot by caching require calls

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bootscale', require: false
```

And then execute:

    $ bundle

Then you need to add `require 'bootscale'` right after `require 'bundler/setup'`.
If your application is a Rails application, you will find this in `config/boot.rb`.

### Important

You must regenerate the cache everytime `$LOAD_PATH` is modified by calling `Bootscale.regenerate`.

For Rails apps it means adding an initializer in `config/application.rb`:

```ruby
module MyApp
  class Application < Rails::Application
    initializer :regenerate_require_cache, after: :set_load_path do
      Bootscale.regenerate
    end
  end
end
```

## Usage

Just install it that's all!

## How much faster is it?

It totally depends on your number of gems. Under 100 gems you likely won't see the difference,
but for bigger applications (300+ gems) it can make the application boot up to 30% faster.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/byroot/bootscale.

Thanks to Aaron Patterson for the idea of converting relative paths to absolute paths.
