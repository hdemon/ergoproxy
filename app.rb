# coding: utf-8
module Ergo end

require "faraday"
require 'excon'
require './request'
require './cache_controller'


class Ergo::App
  @@response_cache = Ergo::CacheController.new

  def call(env)
    @request = Ergo::Request.new env

    if should_use_cache? @request.target_uri
      @@response_cache.get @request.target_uri.to_s
    else
      array = response_array env
      @@response_cache.set @request.target_uri.to_s, array
      array
    end
  end

  def response_array(env)
    conn = Faraday.new(url: @request.target_origin) do |faraday|
      faraday.adapter :excon
    end

    env = conn.get(@request.target_uri.path) do |req|
      req.headers = @request.headers
    end.env

    [
      env.response_headers.delete("status"),
      env.response_headers,
      [env.body],
    ]
  end

  def should_use_cache?(target_uri)
    @@response_cache.exist?(target_uri.to_s) && !@@response_cache.expired?(target_uri.to_s)
  end
end
