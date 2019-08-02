module Fastlane
  module Actions
    module SharedValues
      CREATE_VERSION_NUMBER_VERSION = :CREATE_VERSION_NUMBER_VERSION
    end

    class CreateVersionNumberAction < Action
      require 'yaml'
      def self.run(params)
        changelog_file = File.join('.', params[:changelog])
        project = File.join('..', params[:xcodeproj])
        # Version structure is: MAJOR.MINOR.PATCH

        readme_data = YAML.load_file(String(changelog_file))
        upcoming_version = readme_data["upcoming"]["version"]

        current_version = other_action.get_version_number(xcodeproj: project)
        current_version_elements = current_version.split(".")
        current_major = current_version_elements[0]
        current_minor = current_version_elements[1]
        current_patch = current_version_elements[2]
        
        upcoming_version_elements = upcoming_version.split(".")
        upcoming_major = upcoming_version_elements[0]
        upcoming_minor = upcoming_version_elements[1]
        
        # New version must be greater than current
        if current_major.to_i < upcoming_major.to_i
          UI.user_error!("New version number must be greater than current version number")      
        end
    
        # We check whether major and minor are the same.
        # In that case we increment patch, otherwise we start patch from 0
        is_patch = current_major == upcoming_major && current_minor == upcoming_minor
        upcoming_patch = is_patch ? "#{current_patch.to_i + 1}" : "0"
        
        upcoming_version_full = "#{upcoming_major}.#{upcoming_minor}.#{upcoming_patch}"
        Actions.lane_context[SharedValues::CREATE_VERSION_NUMBER_VERSION] = upcoming_version_full
        UI.message("New version: #{upcoming_version_full}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Creates a new version number based on the upcoming version from changelog file"
      end

      def self.details
        "Use this action to create version number for the next version. Version will be in MAJOR.MINOR.PATCH format. For more information see NumVersion structure."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :changelog,
                                       env_name: "FL_CREATE_VERSION_NUMBER_CHANGELOG", # The name of the environment variable
                                       description: "Changelog file name with path relative to Fastfile", # a short description of this parameter
                                       is_string: true,
                                       verify_block: proc do |value|
                                         changelog_file = File.join('.', value)
                                         UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(changelog_file)
                                       end),
          FastlaneCore::ConfigItem.new(key: :xcodeproj,
                                       env_name: "FL_CREATE_VERSION_NUMBER_XCDEPROJ",
                                       description: "XCode project name",
                                       is_string: true, # true: verifies the input is a string, false: every kind of value
                                       verify_block: proc do |value|
                                         UI.user_error!("Xcode project name must not be empty") unless not value.empty?
                                       end),

        ]
      end

      def self.output
        [
          ['CREATE_VERSION_NUMBER_VERSION', 'Created version of the software based on changelog entry']
        ]
      end

      def self.return_value
      end

      def self.authors
        ["johnny12000"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
