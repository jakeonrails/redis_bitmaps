require 'spec_helper'

describe RedisBitmaps::RedisBitmap do

  before(:all) do
    @redis = Redis.new(:host => 'localhost', :port => 6379)
  end

  let(:redis) { @redis }
  let(:key) { 'my_key' }
  let(:bitmap) {
    bitmap = RedisBitmaps::RedisBitmap.new(key)
    bitmap.clear
    bitmap
  }

  before { bitmap }

  describe '#new' do
    it 'remember the key' do
      bitmap.key.should == key
    end

    it 'should set the redis if passed' do
      bitmap = RedisBitmaps::RedisBitmap.new(key, :redis => redis)
      bitmap.instance_eval("redis").should == redis
    end
  end

  describe '#set' do
    it 'should set the nth bit' do
      bitmap.set(12, 1)
      bitmap.get(12).should == 1
    end
  end

  describe '#[]=' do
    it 'should set the nth bit' do
      bitmap[12] = 1
      bitmap[12].should == 1
    end
  end

  describe '#get' do
    it 'should return the nth bit' do
      bitmap.set(16, 1)
      bitmap.get(16).should == 1
    end
  end

  describe '#[]' do
    it 'should return the nth bit' do
      bitmap.set(16, 1)
      bitmap[16].should == 1
    end
  end

  describe '#count' do
    it 'should return the number of bits set to true (1)' do
      bitmap.count.should == 0
      bitmap.set(1, 1)
      bitmap.count.should == 1
      bitmap.set(2, 1)
      bitmap.count.should == 2
      bitmap.set(1, 0)
      bitmap.count.should == 1
      bitmap.set(1024, 1)
      bitmap.count.should == 2
    end
  end

  describe '#clear' do
    it 'should set all bits to 0' do
      1.upto(16) do |n|
        bitmap[n] = 1
      end
      bitmap[1600] = 1
      bitmap.clear
      1.upto(1600) do |n|
        bitmap[n].should == 0
      end
    end
  end

  describe 'logical operators' do

    let(:odds) { RedisBitmaps::RedisBitmap.new('odds') }
    let(:evens) { RedisBitmaps::RedisBitmap.new('evens') }

    let(:odd_values)  { [0,1,0,1,0] }
    let(:even_values) { [1,0,1,0,1] }

    before do
      [odds, evens].each(&:clear)
      odd_values.each_with_index do |value, index|
        odds[index] = value
      end
      even_values.each_with_index do |value, index|
        evens[index] = value
      end
    end

    describe '#|' do
      it 'should return the count of two bitsets logically ORed together' do
        result = odds | evens
        result.should == 5
      end

      it 'should not matter the order' do
        result = evens | odds
        result.should == 5
      end
    end

    describe '#&' do
      let(:odd_values)  { [1,1,1,0] }
      let(:even_values) { [1,0,1,0] }

      it 'should return the count of two bitsets logically ANDed together' do
        result = odds & evens
        result.should == 2
      end

      context 'with different sized bitmaps' do
        let(:odd_values)  { [1,0,1,0] * 100 }
        let(:even_values) { [1,0,1,0] }

        it 'should assume all bits are 0 for the shorter bitmap' do
          result = odds & evens
          result.should == 2
        end

        it 'should not matter the order' do
          result = evens & odds
          result.should == 2
        end
      end

    end

  end

end
