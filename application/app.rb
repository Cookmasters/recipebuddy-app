# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module RecipeBuddy
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'presentation/views'
    plugin :assets, css: 'style.css', path: 'presentation/assets'
    plugin :flash

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    route do |routing|
      routing.assets

      # GET / request
      routing.root do
        recipes_json = ApiGateway.new.best_recipes.message
        best_recipes = RecipeBuddy::RecipesRepresenter.new(OpenStruct.new)
                                                      .from_json recipes_json

        recipes = Views::AllRecipes.new(best_recipes)
        if recipes.none?
          flash.now[:notice] = 'Add a Facebook public page to get started'
        end
        view 'home', locals: { recipes: recipes }
      end

      routing.on 'page' do
        routing.is String do |pagename|
          # GET /api/v0.1/page/:pagename request
          page_json = ApiGateway.new.get_page(pagename).message
          page = RecipeBuddy::PageRepresenter.new(OpenStruct.new)
                                             .from_json page_json

          view_page = Views::Page.new(page)
          view 'page', locals: { page: view_page }
        end

        routing.post do
          create_request = Forms::FacebookPageURLValidator.call(routing.params)
          result = AddPage.new.call(create_request)

          if result.success?
            page =
              RecipeBuddy::PageRepresenter
              .new(OpenStruct.new)
              .from_json result.value[:response]

            flash[:notice] = 'New Facebook Page added!'
            routing.redirect '/page/' + page.name
          else
            flash[:error] = result.value
            routing.redirect '/'
          end
        end
      end

      routing.on 'recipe' do
        routing.is Integer do |recipe_id|
          # GET /api/v0.1/page/:pagename request
          recipe_json = ApiGateway.new.get_recipe(recipe_id).message
          recipe = RecipeBuddy::RecipeRepresenter.new(OpenStruct.new)
                                                 .from_json recipe_json

          view_recipe = Views::Recipe.new(recipe)
          view 'recipe', locals: { recipe: view_recipe }
        end
      end
    end
  end
end
