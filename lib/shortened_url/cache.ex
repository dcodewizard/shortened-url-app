defmodule ShortenedUrl.Cache do
  alias Cachex

  # Start the cache
  def start_link(opts) do
    Cachex.start_link(opts)
  end

  # Put a key-value pair into the cache
  def put(key, value) do
    Cachex.put(:my_cache, key, value)
  end

  # Get the value associated with a key from the cache
  def get(key) do
    Cachex.get(:my_cache, key)
  end
end
