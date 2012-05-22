require "redis_bitmaps/version"
require "redis_bitmaps/configuration"
require "redis_bitmaps/redis_bitmap"
require "redis_bitmaps/active_record"

module RedisBitmaps
  # Returns the global Configuration object
  # Generally, though, use the RedisBitmaps.configure method with a block.
  def self.configuration
    @configuration ||= RedisBitmaps::Configuration.new
  end

  # Yields the global configuration to a block.
  #
  # Example:
  #   RedisBitmaps.configure do |config|
  #     config.redis_url = 'localhost:6379'
  #   end
  def self.configure
    yield configuration if block_given?
  end
end
