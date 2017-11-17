# frozen_string_literal: true

require 'roda'

module RecipeBuddy
  # Web App
  class App < Roda
    plugin :halt

    route do |routing|
      # app = App

      # GET / request
      routing.root do
      end

      routing.on '' do
      end
    end
  end
end
