class Post < ActiveRecord::Base
  include RedisBitmaps::ActiveRecord

end
