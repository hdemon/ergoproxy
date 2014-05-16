# coding: utf-8

require "faraday"
require 'excon'
require 'uri'
# require 'pry'

class App
  def call(env)
    @env = env

    uri = URI.parse URI.decode params["target_uri"]
    conn = Faraday.new(url: origin(uri)) do |faraday|
      faraday.adapter :excon
    end

    env = conn.get(uri.path) do |req|
      req.headers = request_headers
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

  def origin(uri)
    uri.scheme +
      "://" + uri.host +
      (uri.port ? ":#{uri.port.to_s}" : '')
  end

  def request_headers
    @env.select {|k,v| k.start_with? 'HTTP_'}.each_with_object({}) do |array, hash|
      hash[array[0].sub(/^HTTP_/, '')] = array[1]
    end.tap { |hash| hash.delete('HOST') }
  end

  def params
    @env["QUERY_STRING"].split('&').each_with_object({}) do |string, object|
      parts = string.split '='
      object[parts[0]] = parts[1]
    end
  end
end
