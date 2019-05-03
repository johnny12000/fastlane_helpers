# fastlane_helpers
Small fastlane actions that make my life easier

Included helper actions:
1. create_release_notes - Creates a release notes text from the changelog file
2. create_version_number - Creates a version number based on changelog file data
3. create_build_number - Creates a build number based on current time and date

# Changelog file #
Changelog.yml file should contain two big sequences:

## Upcoming ##
Upcoming version, the most important sequence of the file with all important data for the new version.
This sequence contains:
* version: new version of the application, in format MAJOR.MINOR.REVISION
* details: description of the versin
* dev: developer related info, could be anything that is useful (e.g. links to tasks, tasks descriptions, links, etc.)
* user_facing: information that will be used to generate user-facing text

## Releases ##
This is a sequence that contains all previous releases of the app. This is kept for the reference value, although not important.
Advice is to move the upcoming data to this list after the release is done, and to replace the upcoming sequence with new.

## Example ##
``` yaml
upcoming:
  version: '1.1.0'
  details: A short description of the version, what is new or different.
  dev:
    infrastructure:
      - Infrastructural change 1
      - Infrastructurel change 2
    bugs:
      - Bug fix 1
      - Bug fix 2
      - Bug fix 3
  user_facing:
    - Text about version change that will be displayed to the user 1
    - Text about version change that will be displayed to the user 2
releases:
  - version: '1.1.0'
  details: A short description of the version, what is new or different.
  dev:
    infrastructure:
      - Infrastructural change 1
      - Infrastructurel change 2
    bugs:
      - Bug fix 1
      - Bug fix 2
      - Bug fix 3
  user_facing:
    - Text about version change that will be displayed to the user 1
    - Text about version change that will be displayed to the user 2
  - version: '1.1.0'
	details: A short description of the version, what is new or different.
	dev:
	  infrastructure:
        - Infrastructural change 1
        - Infrastructurel change 2
      bugs:
        - Bug fix 1
        - Bug fix 2
        - Bug fix 3
    user_facing:
      - Text about version change that will be displayed to the user 1
      - Text about version change that will be displayed to the user 2
```
# Usage
Add to project README.yml file with data about new app version.
Change existing or create new fastlane script with usage of the helper actions
Pass readme path as an input parameter. __Note:__ Path should be relative to root folder of the project

```ruby

	## environment variable with readme file path
    ENV["CHANGELOG"] = 'CHANGELOG.yml'
	
	## creates version number and adds it to environment variable
	create_version_number(changelog: ENV["CHANGELOG"] , xcodeproj: "ayoApp.xcodeproj")
    ENV["VERSION_NUMBER"] = Actions.lane_context[SharedValues::CREATE_VERSION_NUMBER_VERSION]

	## creates build number and adds it to environment variable
    create_build_number
    ENV["BUILD_NUMBER"] = Actions.lane_context[SharedValues::CREATE_BUILD_NUMBER_VALUE]
	
	## creates release notes and adds it to environment variable
    create_release_notes(changelog: ENV["CHANGELOG"])
    ENV["RELEASE_NOTES"] = Actions.lane_context[SharedValues::CREATE_RELEASE_NOTES_TEXT_TEXT]

```

