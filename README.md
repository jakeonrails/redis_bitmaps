# RedisBitmaps

This gem should make it easy to create and use large bitmaps to do stat-tracking and metrics as seen in this post (http://blog.getspool.com/2011/11/29/fast-easy-realtime-metrics-using-redis-bitmaps/).

## Installation

Add this line to your application's Gemfile:

    gem 'redis_bitmaps'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis_bitmaps

## Usage

Configure the default Redis connection:

  RedisBitmaps.configure do |config|
    config.host = 'localhost'
    config.port = 6379
  end

Create a bitmap:

  active_users = RedisBitmaps.new('active_users')

When a user logs in:

  active_users.set(user.id, 1)

When a user logs out:

  active_users.set(user.id, 0)

Count active users:

  active_users.count(1)

Count inactive users:

  active_users.count(0)

Count total users:

  active_users.total

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
