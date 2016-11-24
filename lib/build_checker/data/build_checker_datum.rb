module BuildChecker
  module Data
    class BuildCheckerDatum < ActiveRecord::Base
      belongs_to :template
      belongs_to :location #seems redundant, but helps in queries

      validates :template, :location, presence: true
      validate :proper_location_id

      enum state: {
        scheduled:  0, # default
        building:   1,
        to_monitor: 2,
        monitoring: 3,
        to_clean:   4,
        cleaning:   5,
        finished:   6
      }

      enum build_result: {
        waiting: 0, # default
        success: 1,
        failed:  2
      }

      def build_time
        return false if build_start.nil? || build_end.nil?
        build_end - build_start
      end

      def delete_time
        return false if delete_queued_at.nil? || deleted_at.nil?
        deleted_at - delete_queued_at
      end

      private
        def proper_location_id
          unless template.try(:location_id) == location_id
            errors.add(:location_id, "is not the same as template's location")
          end
        end
    end
  end
end