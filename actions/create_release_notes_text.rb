module Fastlane
  module Actions
    module SharedValues
      CREATE_RELEASE_NOTES_TEXT_TEXT = :CREATE_RELEASE_NOTES_TEXT_TEXT
    end

    class CreateReleaseNotesTextAction < Action
      require 'yaml'
      def self.run(params)
        changelog_file = File.join('.', params[:changelog])
        readme_yaml = File.read(changelog_file)
        readme_data = YAML.load(readme_yaml)
        upcoming = readme_data["upcoming"]
        release_notes = "- #{upcoming["user_facing"].join "\n- "} \n\n"
        UI.message("Release notes:\n#{release_notes}")
        Actions.lane_context[SharedValues::CREATE_RELEASE_NOTES_TEXT_TEXT] = release_notes
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Creates a readme text for deployment"
      end

      def self.details
        "Creates a readme text for deployment"
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
        ]
      end

      def self.output
        [
          ['CREATE_RELEASE_NOTES_TEXT_TEXT', 'Release notes text that should be written in metadata file.']
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
