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

      def id
        @recipe.id
      end

      def full_picture
        @recipe.full_picture
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

      def link
        "/recipe/#{id}"
      end

      def negative_reactions
        @recipe.reactions_sad + @recipe.reactions_angry
      end

      def ingredients_links
        enable_links = ingredients
        urls = URI.extract(enable_links, %w[http https])
        urls.each do |url|
          enable_links.gsub!(url,
                             "<a href=#{url} target='_blank' class='btn btn-primary'>Click here</a>")
        end
        enable_links
      end
    end
  end
end
