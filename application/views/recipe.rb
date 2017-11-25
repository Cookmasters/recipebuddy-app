# frozen_string_literal: true

module RecipeBuddy
  module Views
    # View object for a single Facebook recipe
    class Recipe
      def initialize(recipe)
        @recipe = recipe
      end

      def title
        @recipe.title
      end

      def page
        'Powered by ' #+ recipe.page.name
      end

      def ingredients
        @recipe.content.to_s.gsub(/\n/, '<br/>')
      end

      def positive_reactions
        @recipe.reactions_like +
          @recipe.reactions_love +
          @recipe.reactions_wow +
          @recipe.reactions_haha
      end

      def negative_reactions
        @recipe.reactions_sad + @recipe.reactions_angry
      end
    end
  end
end
