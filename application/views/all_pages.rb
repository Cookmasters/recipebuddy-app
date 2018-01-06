# frozen_string_literal: true

module RecipeBuddy
  module Views
    # View object for collection of Facebook pages
    class AllPages
      def initialize(all_pages)
        @all_pages = all_pages
      end

      def none?
        @all_pages.pages.none?
      end

      def any?
        @all_pages.pages.any?
      end

      def collection
        @all_pages.pages.map { |page| Page.new(page) }
      end
    end
  end
end
