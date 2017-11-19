# frozen_string_literal: true

require 'roda'

module RecipeBuddy
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'presentation/views'
    plugin :assets, css: 'style.css', path: 'presentation/assets'

    route do |routing|
      routing.assets
      app = App

      # GET / request
      routing.root do
        recipes_json = ApiGateway.new.all_recipes
        all_recipes = RecipeBuddy::RecipesRepresenter.new(OpenStruct.new)
                                                     .from_json recipes_json
        view 'home', locals: { recipes: all_recipes.recipes }
      end

      routing.on 'page' do
        routing.post do
          pagename = routing.params['pagename'].downcase
          ApiGateway.new.create_page(pagename)
          routing.redirect '/'
        end
      end
    end
  end
end
