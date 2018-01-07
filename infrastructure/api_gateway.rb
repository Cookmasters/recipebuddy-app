# frozen_string_literal: true

require 'http'

module RecipeBuddy
  # API gateway
  class ApiGateway
    # API response
    class ApiResponse
      HTTP_STATUS = {
        200 => :ok,
        201 => :created,
        202 => :processing,
        204 => :no_content,

        403 => :forbidden,
        404 => :not_found,
        400 => :bad_request,
        409 => :conflict,
        422 => :cannot_process,

        500 => :internal_error
      }.freeze

      attr_reader :status, :message

      def initialize(code, message)
        @code = code
        @status = HTTP_STATUS[code]
        @message = message
      end

      def ok?
        HTTP_STATUS[@code] == :ok
      end

      def processing?
        HTTP_STATUS[@code] == :processing
      end
    end

    def initialize(config = RecipeBuddy::App.config)
      @config = config
    end

    def all_recipes
      call_api(:get, %w[recipe all])
    end

    def best_recipes
      call_api(:get, %w[recipe best])
    end

    def search_recipes(keyword)
      call_api(:get, ['recipe', 'search', keyword])
    end

    def all_pages
      call_api(:get, %w[page all])
    end

    def get_page(pagename)
      call_api(:get, ['page', pagename])
    end

    def get_recipe(recipe_id)
      call_api(:get, ['recipe', recipe_id])
    end

    def create_page(pagename)
      call_api(:post, ['page', pagename])
    end

    def delete_all_recipes
      call_api(:delete, 'recipe')
    end

    def call_api(method, resources)
      url_route = [@config.API_HOST, @config.API_VER, resources].flatten
                                                                .join('/')

      result = HTTP.send(method, url_route)
      result_code = result.code
      raise(result.parse['message']) if result_code >= 300
      ApiResponse.new(result_code, result.to_s)
    end
  end
end
