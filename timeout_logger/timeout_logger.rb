# Based on code seen in this blog post: (http://underthehood.meltwater.com/blog/2014/03/21/debugging-unicorn-rails-timeouts/)
# and in this youtube video: https://www.youtube.com/watch?v=NpTT30wLL-w
class TimeoutLogger
  UNICORN_TIMEOUT = 30

  def initialize(app)
    @app = app
  end

  def call(env)
    thr = Thread.new do
      sleep(UNICORN_TIMEOUT - 1) # set this to Unicorn timeout - 1
      unless Thread.current[:done]
        path = env["PATH_INFO"]
        query_string = env["QUERY_STRING"] && path += "?#{query_string}"
        env["RAW_POST_DATA"] && body = env["RAW_POST_DATA"]
        Rails.logger.warn "[TIMEOUT] Unicorn worker timeout: path => #{path}, body => #{body}"
      end
    end
    @app.call(env)
  ensure
    thr[:done] = true
    thr.run
  end
end
