# frozen_string_literal: true

require 'dry/transaction'

module RecipeBuddy
  # Transaction to add Facebook page to API
  class AddPage
    include Dry::Transaction

    step :validate_input
    step :add_page

    def validate_input(input)
      if input.success?
        pagename = input[:page_url].split('/')[-1]
        Right(pagename: pagename)
      else
        Left(input.errors.values.join('; '))
      end
    end

    def add_page(input)
      response = ApiGateway.new.create_page(input[:pagename])
      Right(response: response)
    rescue StandardError => error
      Left(error.to_s)
    end
  end
end
