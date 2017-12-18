# frozen_string_literal: true

module RecipeBuddy
  module Views
    # View object for a single Facebook recipe
    class Recipe
      def videos
        @recipe.videos
      end

      def video_link(order)
        order -= 1
        "//www.youtube.com/embed/#{@recipe.videos[order].origin_id}"
      end
    end
  end
end
