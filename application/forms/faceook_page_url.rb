# frozen_string_literal: true

require 'dry-validation'

module RecipeBuddy
  module Forms
    FacebookPageURLValidator = Dry::Validation.Form do
      FACEBOOK_PAGE_URL_REGEX = %r{(http[s]?)\:\/\/www\.facebook\.com\/.*$}

      required(:page_url).filled(:str?, format?: FACEBOOK_PAGE_URL_REGEX)

      configure do
        config.messages_file = File.join(__dir__,
                                         'errors/facebook_page_url.yml')
      end
    end
  end
end
