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

      def recipes
        AllRecipes.new(@page)
      end
    end
  end
end
