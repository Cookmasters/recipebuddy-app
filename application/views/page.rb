# frozen_string_literal: true

module RecipeBuddy
  module Views
    # View object for a single Facebook Page
    class Page
      def initialize(page)
        @page = page
      end

      def name
        @page.name
      end

      def link
        'https://www.facebook.com/' + name
      end

      def loading?
        return true if ws_channel_id
        false
      end

      def recipes
        AllRecipes.new(@page)
      end

      def ws_channel_id
        @page.request_id
      end

      def ws_host
        App.config.API_HOST
      end
    end
  end
end
