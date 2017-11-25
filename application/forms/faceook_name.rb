# frozen_string_literal: true

require 'dry-validation'

module RecipeBuddy
  module Forms
    FacebookNameValidator = Dry::Validation.Form do
      PAGENAME_REGEX = /^[0-9a-zA-Z]*$/

      required(:page_name).filled(:str?, format?: PAGENAME_REGEX)

      configure do
        config.messages_file = File.join(__dir__, 'errors/facebook_name.yml')
      end
    end
  end
end
