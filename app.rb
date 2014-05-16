# coding: utf-8

require "faraday"
require 'excon'
require './request'
# require 'pry'

class App
  def call(env)
    request = Request.new env

    conn = Faraday.new(url: request.target_origin) do |faraday|
      faraday.adapter :excon
    end

    env = conn.get(request.target_uri.path) do |req|
      req.headers = request.headers
    end.env

    response_array env
  end

  def response_array(env)
    [
      env.response_headers.delete("status"),
      env.response_headers,
      [env.body],
    ]
  end
end
