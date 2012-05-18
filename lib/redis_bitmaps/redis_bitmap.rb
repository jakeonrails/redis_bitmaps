module RedisBitmaps
  class RedisBitmap

    attr_reader :key
    def initialize(key, redis = nil)
      @key = key
      @redis = redis || Redis.new
    end

    def set(bit, value)
      redis.setbit(key, bit, value)
    end

    def get(bit)
      redis.getbit(key, bit)
    end

    protected

    attr_reader :redis
  end
end
