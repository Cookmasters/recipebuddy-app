# frozen_string_literal: true

require 'http'

module RecipeBuddy
  class ApiGateway
    def initialize(config = RecipeBuddy::App.config)
      @config = config
    end

    def all_recipes
      call_api(:get, 'recipes')
    end

    def page(pagename)
      call_api(:get, ['page', pagename])
    end

    def create_page(pagename)
      call_api(:post, ['page', pagename])
    end

    def call_api(method, resources)
      url_route = [@config.api_url, resources].flatten.join'/'

      result = HTTP.send(method, url_route)
      raise(result.to_s) if result.code >= 300
      result.to_s
    end
  end
end
