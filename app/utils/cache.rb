require 'redis'
require 'zlib'

module Utils
  ##
  # Cache utils
  #
  module Cache
    DEFAULT_TTL = 25 * 60 # 25 minutes
    CACHE_TTL = Integer(ENV['CACHE_TTL'] || DEFAULT_TTL)

    ##
    # Load value from cache.
    #
    # @param key[String] The cache key
    # @param ttl[Integer] Time to live of the cache key
    # @param block[Block] The block to yeld if there is no value in cache
    #
    def load_from_cache(key, ttl: CACHE_TTL, &block)
      return yield block if cache_disabled?
      cached_result = read_cache_value(key)
      return cached_result if cache_exists?(key)

      return unless block_given?
      result = yield block
      write_cache_value(key, ttl, result)
    end

    ##
    # Write a value in the cache.
    #
    # @param key[String] the namespace of the key in the cache.
    # @param ttl[Integer] the time to live of the key
    # @param value[Any] The value to write in the cache:
    # It's serialized so it can be any format.
    #
    def write_cache_value(key, ttl, value)
      Redis.current.setex(key, ttl, cache_serialize(value))
      value
    end

    ##
    # Read a value from the cache.
    #
    # @param key[String] The key we want to retrieve from the cache.
    #
    # @result [Any] Deserialized value from the cache.
    #
    def read_cache_value(key)
      return unless key && cache_exists?(key)
      value = Redis.current.get(key)
      value.nil? ? nil : cache_deserialize(value)
    end

    ##
    # Define the cache key prefix.
    #
    # @param key[String] the key to add to the cache.
    # @param attributes[Array] List of optionnal parameters.
    #
    # @result [String] SHA256 of the key + attributes
    #
    def cache_key(key, *attributes)
      prefix = "#{ENV['CACHE_PREFIX']}:#{key}"
      args = attributes.join('-')
      "#{prefix}:#{Digest::SHA256.hexdigest(args)}"
    end

    private

    def cache_disabled?
      ENV['DISABLE_CACHE'].to_s == 'true'
    end

    def cache_exists?(key)
      Redis.current.exists(key)
    end

    def cache_deserialize(value)
      return nil if value.nil?
      binary = Zlib::Inflate.inflate(value)
      Marshal.load(binary)
    rescue
      nil
    end

    def cache_serialize(data)
      Zlib::Deflate.deflate(Marshal.dump(data), Zlib::BEST_COMPRESSION)
    end
  end
end
