# Bootscale

Speedup applications boot by caching require calls.

Speed gain depends on your number of gems. Under 100 gems you likely won't see the difference,
but for bigger applications (300+ gems) it can make the application boot up to 30% faster.


## Installation

```ruby
# Gemfile
gem 'bootscale', require: false
```

Then you need to add right after `require 'bundler/setup'`:

```ruby
require 'bundler/setup'
require 'bootscale'
Bootscale.setup(cache_directory: 'tmp/bootscale')
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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/byroot/bootscale.

Thanks to Aaron Patterson for the idea of converting relative paths to absolute paths.
