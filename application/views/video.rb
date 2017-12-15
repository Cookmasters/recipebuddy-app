# frozen_string_literal: true

module RecipeBuddy
  module Views
    # View object for a single Facebook recipe
    class Recipe
      def video_link(order)
        "//www.youtube.com/embed/#{@recipe.videos[order-1].origin_id}"
      end
    end
  end
end
