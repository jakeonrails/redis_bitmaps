require 'spec_helper'

describe RedisBitmaps::ActiveRecord do

  before do
    Post.delete_all
    Post.count.should == 0
    5.times do
      Post.create!
    end
    Post.generate_presence_bitmap
  end

  describe '.presence_bitmap' do
    it 'should generate a presence bitmap' do
      Post.count.should == 5
      Post.presence_bitmap.count.should == 5
    end
  end

  describe '#remove_from_presence_bitmap' do
      it 'should deduct 1 from the total count' do
        count = Post.count
        Post.last.destroy
        Post.count.should == 4
        Post.presence_bitmap.count.should == count - 1
      end
    end

  describe '#add_to_presence_bitmap' do
    it 'should add 1 to the total count' do
      count = Post.count
      Post.create!
      Post.count.should == count + 1
      Post.presence_bitmap.count.should == count + 1
    end
  end

end
