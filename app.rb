# coding: utf-8

require "faraday"
require 'excon'
require 'uri'
# require 'pry'


class Request
  def initialize(env)
    @env = env
  end

  def target_uri
    URI.parse URI.decode params["target_uri"]
  end

  def target_origin
    target_uri.scheme +
      "://" + target_uri.host +
      (target_uri.port ? ":#{target_uri.port.to_s}" : '')
  end

  def headers
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
