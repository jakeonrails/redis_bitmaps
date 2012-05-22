module RedisBitmaps
  class Configuration
    def redis
      Redis.new(:host => 'localhost', :port => 6379)
    end
  end
end
