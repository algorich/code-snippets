# Unicorn timeout logger

Rack middleware to log each request that causes a timeout in your unicorn workers.
It will log those requests with a `[TIMEOUT]` prefix for easy finding with `grep`.

This snippet was based on
[this blog post in Meltwater blog, by Salimane](http://underthehood.meltwater.com/blog/2014/03/21/debugging-unicorn-rails-timeouts/),
and [this awesome presentation by Andy at Cascadia Ruby](https://www.youtube.com/watch?v=NpTT30wLL-w).

## Instructions

Just copy the `timeout_logger.rb` file to the `lib` folder, inside your Rails project
and add the following code to your `config/application.rb` in the `Application` class:

```ruby
config.middleware.use 'TimeoutLogger'
```

## IMPORTANT!

At least, but not less important, remember to **set the constant** `UNICORN_TIMEOUT`
inside the `TimeoutLogger` class **to match your unicorn's  worker timeout**.
