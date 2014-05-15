# coding: utf-8

class Proxy
  def initialize(app)
    @app = app
  end

  def call(env)
    res = @app.call(env)
    [
      res.response_headers.delete("status"),
      res.response_headers,
      [res.body],
    ]
  end
end
