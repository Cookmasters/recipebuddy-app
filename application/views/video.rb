# frozen_string_literal: true

module RecipeBuddy
  module Views
    # View object for a single Facebook recipe
    class Recipe
      def videos
        @recipe.videos
      end

      def video_link(origin_id)
        "//www.youtube.com/embed/#{origin_id}"
      end
    end
  end
end
