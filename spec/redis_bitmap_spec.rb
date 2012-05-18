require 'spec_helper'

describe RedisBitmaps::RedisBitmap do

  before(:all) do
    @redis = Redis.new(:host => 'localhost', :port => 6379)
  end

  let(:redis) { @redis }
  let(:key) { 'my_key' }
  let(:bitmap) { RedisBitmaps::RedisBitmap.new(key) }

  describe '#new' do
    it 'remember the key' do
      bitmap.key.should == key
    end
  end

  describe '#set' do
    it 'should set the bit on the redis key' do
      bitmap.set(12, 1)
      redis.getbit(key, 12).should == 1
    end
  end

  describe '#get' do
    it 'should return the bit on the redis key' do
      redis.setbit(key, 16, 1)
      bitmap.get(16).should == 1
    end
  end

end
