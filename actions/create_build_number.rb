module Fastlane
  module Actions
    module SharedValues
      CREATE_BUILD_NUMBER_VALUE = :CREATE_BUILD_NUMBER_VALUE
    end

    class CreateBuildNumberAction < Action
      def self.run(params)
        Actions.lane_context[SharedValues::CREATE_BUILD_NUMBER_VALUE] = Time.now.strftime("%j%H%m%S")
        UI.message("New build: #{Actions.lane_context[SharedValues::CREATE_BUILD_NUMBER_VALUE]}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Creates build number based on date"
      end

      def self.details
        "Creates build number based on date"
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
        ]
      end

      def self.output
        [
          ['CREATE_BUILD_NUMBER_VALUE', 'New build number']
        ]
      end

      def self.return_value
      end

      def self.authors
        ["johnny12000"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
