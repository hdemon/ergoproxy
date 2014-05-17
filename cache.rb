# coding: utf-8

class Ergo::Cache
  def initialize
    @cache = {}
  end

  def set(key, value)
    @cache[key] = value
  end

  def get(key)
    @cache[key]
  end

  def clear(key)
    @cache.delete(key)
  end

  def exist?(key)
    !@cache[key].nil?
  end
end
