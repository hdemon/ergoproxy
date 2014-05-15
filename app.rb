# coding: utf-8

require "faraday"
require 'uri'

class App
  def call(env)
    @params = parse_params env["QUERY_STRING"]

    uri = URI.parse target_uri_string
    target_uri = uri.scheme +
                 "://" + uri.host +
                 (uri.port ? ":#{uri.port.to_s}" : '')

    conn = Faraday.new url: target_uri
    res = conn.get(uri.path).env

    response_array res
  end

  def response_array(res)
    [
      res.response_headers.delete("status"),
      res.response_headers,
      [res.body],
    ]
  end

  def target_uri_string
    URI.decode @params["target_uri"]
  end

  def parse_params(query_string)
    query_string.split('&').each_with_object({}) do |string, object|
      parts = string.split '='
      object[parts[0]] = parts[1]
    end
  end
end
