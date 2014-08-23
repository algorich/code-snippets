# Unicorn timeout logger

Rack middleware to log each request that causes a timeout in your unicorn workers.
It will log those requests with a `[TIMEOUT]` prefix for easy finding with `grep`.

## Instructions

Just copy the `timeout_logger.rb` file to the `lib` folder, inside your Rails project
and add the following code to your `config/application.rb` in the `Application` class:

```ruby
config.middleware.use 'TimeoutLogger'
```

At least, but not less important, remember to set the constant `UNICORN_TIMEOUT`
inside the `TimeoutLogger` class to match your unicorn's  worker timeout.
