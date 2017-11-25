# frozen_string_literal: true

module RecipeBuddy
  module Views
    # View object for collection of Facebook recipes
    class AllRecipes
      def initialize(all_recipes)
        @all_recipes = all_recipes
      end

      def none?
        @all_recipes.recipes.none?
      end

      def any?
        @all_recipes.recipes.any?
      end

      def collection
        @all_recipes.recipes.map { |recipe| Recipe.new(recipe) }
      end
    end
  end
end
