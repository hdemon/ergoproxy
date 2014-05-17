# coding: utf-8

require 'yaml'

class Ergo::Cache
  def initialize
    @cache = {}
    @previous_access_time = {}
    @config = YAML.load_file 'cache.yaml'
  end

  def set(key, value)
    @previous_access_time[key] = Time.now.to_i
    @cache[key] = value
  end

  def get(key)
    @cache[key]
  end

  def clear(key)
    @cache.delete(key)
  end

  def duration(key)
    @config[key]['duration']
  end

  # TODO: DRY up. It is overlapped with Ergo:Request
  def origin(uri_string)
    uri = URI.parse URI.decode uri_string
    uri.scheme +
      "://" + uri.host +
      (uri.port ? ":#{uri.port.to_s}" : '')
  end

  def exist?(key)
    !@cache[key].nil?
  end

  def expired?(key)
    Time.now.to_i >= @previous_access_time[key] + duration(origin key)
  end
end
