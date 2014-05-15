# coding: utf-8

class Proxy
  def initialize(app)
    @app = app
  end

  def call(env)
    res = @app.call(env)
    p res
    res[2].each do |body|
      body.gsub!(/！|？|。|，/) { "にゃ#{$&}" }
    end
    res
  end
end
