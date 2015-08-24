# Bootscale

Speedup applications boot by caching require calls.

Speed gain depends on your number of gems. Under 100 gems you likely won't see the difference,
but for bigger applications it can save 1 to 3 seconds of boot time per 100 used gems.

## Installation

```ruby
# Gemfile
gem 'bootscale', require: false
```

Then you need to add right after `require 'bundler/setup'`:

```ruby
require 'bundler/setup'
require 'bootscale/setup'
```

If your application is a Rails application, you will find this in `config/boot.rb`.

### Important

Cache should be update everytime `$LOAD_PATH` is modified by calling `Bootscale.regenerate`.

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

## Faster cache loading

Add the `msgpack` gem and `require 'msgpack'` to gain ~10-30ms of extra load speed by using msgpack.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/byroot/bootscale.

Local development: your load time will be very slow when using a local copy for development like `gem 'bootscale', path: '~/Code/bootscal'`, use via git instead.

Thanks to Aaron Patterson for the idea of converting relative paths to absolute paths.
