require 'bitset'
require 'redis'

# &: intersection
# |: union
# -: difference
# ^: xor
# not: not
# hamming distance

module RedisBitmaps
  class RedisBitmap

    attr_reader :key
    def initialize(key, options = nil)
      options ||= {}
      @key = key
      @redis = options[:redis] || RedisBitmaps.configuration.redis
    end

    def clear
      redis.set(key, "")
    end

    def set(bit, value)
      redis.setbit(key, bit, value)
    end
    alias_method(:[]=, :set)

    def get(bit)
      redis.getbit(key, bit)
    end
    alias_method(:[], :get)

    def count
      bitset.cardinality
      #redis.bitcount(key)
    end

    def union(rhs)
      rhs = rhs.bitset
      lhs = self.bitset
      result = (lhs | rhs)
      result.cardinality
    end
    alias_method(:|, :union)

    def intersection(rhs)
      rhs = rhs.bitset
      lhs = self.bitset
      if lhs.cardinality > rhs.cardinality
        result = rhs & lhs
      else
        result = lhs & rhs
      end
      result.cardinality
    end
    alias_method(:&, :intersection)

    def to_s
      bitset.to_s
    end

    protected

    attr_reader :redis

    def bitset
      string = redis.get(key).unpack("B*").first
      Bitset.from_s(string)
    end

  end
end
