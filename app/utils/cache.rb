require 'redis'
require 'zlib'

module Utils
  ##
  # Cache utils
  #
  module Cache
    DEFAULT_TTL = 2 * 60 # 25 minutes
    CACHE_TTL = Integer(ENV['CACHE_TTL'] || DEFAULT_TTL)

    ##
    # Load value from cache.
    #
    # @param key[String] The cache key
    # @param ttl[Integer] Time to live of the cache key
    # @param block[Block] The block to yeld if there is no value in cache
    #
    def load_from_cache(key, ttl: CACHE_TTL, &block)
      cached_result = read_cache_value(key)
      return cached_result if cache_exists?(key)

      return unless block_given?
      result = yield block
      write_cache_value(key, ttl, result)
    end

    def write_cache_value(key, ttl, value)
      Redis.current.setex(key, ttl, cache_serialize(value))
      value
    end

    def read_cache_value(key)
      return unless key && cache_exists?(key)
      value = Redis.current.get(key)
      value.nil? ? nil : cache_deserialize(value)
    end

    def cache_key(key, *attributes)
      prefix = "#{ENV['CACHE_PREFIX']}:#{key}"
      args = attributes.join('-')
      "#{prefix}:#{Digest::SHA256.hexdigest(args)}"
    end

    private

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
