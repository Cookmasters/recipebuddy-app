# frozen_string_literal: true

require 'http'

module RecipeBuddy
  # API gateway
  class ApiGateway
    def initialize(config = RecipeBuddy::App.config)
      @config = config
    end

    def all_recipes
      call_api(:get, 'recipe')
    end

    def best_recipes
      call_api(:get, %w[recipe best])
    end

    def all_page
      call_api(:get, 'page')
    end

    def get_page(pagename)
      call_api(:get, ['page', pagename])
    end

    def create_page(pagename)
      call_api(:post, ['page', pagename])
    end

    def delete_all_recipes
      call_api(:delete, 'recipe')
    end

    def call_api(method, resources)
      url_route = [@config.api_url, resources].flatten.join '/'
      result = HTTP.send(method, url_route)
      raise(result.parse['message']) if result.code >= 300
      result.to_s
    end
  end
end
