require 'uri'

class Ergo::Request
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
