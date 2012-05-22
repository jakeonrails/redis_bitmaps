require 'spec_helper'

describe RedisBitmaps::Configuration do

  context 'when no host or port has been set' do

    describe '#redis' do
      it 'should return an instance of Redis pointing to localhost:6379' do
        Redis
      end
    end
  end
end
