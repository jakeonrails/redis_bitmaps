require 'active_record'

module RedisBitmaps
  module ActiveRecord

    def self.included(base)
      base.extend(ClassMethods)
      base.after_destroy(:remove_from_presence_bitmap)
      base.after_create(:add_to_presence_bitmap)
    end

    def remove_from_presence_bitmap
      self.class.presence_bitmap.set(self.id - 1, 0)
    end

    def add_to_presence_bitmap
      self.class.presence_bitmap.set(self.id - 1, 1)
    end

    module ClassMethods
      attr_reader(:presence_bitmap)

      def generate_presence_bitmap
        redis = RedisBitmaps.configuration.redis
        bitmap = presence_bitmap
        # Remove any previous values
        bitmap.clear
        # Set the highest bit to allocate memory for the entire set at once.
        # Todo: Add some reasonable padding amount here to make room to grow as
        # records are added.
        bitmap[maximum(:id) - 1] = 1
        # Iterate the records in batches to get the ids to set bits for
        select('id').find_in_batches(:batch_size => 1000) do |records|
          records.each do |record|
            bitmap[record.id - 1] = 1
          end
        end
        bitmap
      end

      def presence_bitmap
        @presence_bitmap ||= RedisBitmaps::RedisBitmap.new(presence_bitmap_key)
      end

      def presence_bitmap_key
        "#{name}:presence_bitmap_key"
      end

    end
  end
end
