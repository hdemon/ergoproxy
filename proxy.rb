# coding: utf-8

class Proxy
  def initialize(app)
    @app = app
  end

  def call(env)
    res = @app.call(env)
    [
      res.response_headers["status"],
      res.response_headers,
      [body],
    ]
  end
end
