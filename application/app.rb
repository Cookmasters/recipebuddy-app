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
        title = 'Our best recipes'
        view 'recipes', locals: { recipes: recipes, title: title }
      end

      # # /page branch
      routing.on 'page' do
        # # /page/all branch
        routing.on 'all' do
          # GET # /page/all request
          routing.get do
            pages_json = ApiGateway.new.all_pages.message
            all_pages = RecipeBuddy::PagesRepresenter.new(OpenStruct.new)
                                                     .from_json pages_json
            view_pages = Views::AllPages.new(all_pages)
            title = 'All the pages available'
            view 'pages', locals: { pages: view_pages, title: title }
          end
        end

        # GET # /page/:pagename request
        routing.is String do |pagename|
          page_json = ApiGateway.new.get_page(pagename).message
          page = RecipeBuddy::PageRepresenter.new(OpenStruct.new)
                                             .from_json page_json

          view_page = Views::Page.new(page)
          view 'page', locals: { page: view_page }
        end

        # POST # /page request
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

      # # /recipe branch
      routing.on 'recipe' do
        # GET # /recipe/:recipe_id request
        routing.is Integer do |recipe_id|
          recipe_json = ApiGateway.new.get_recipe(recipe_id).message
          recipe = RecipeBuddy::RecipeRepresenter.new(OpenStruct.new)
                                                 .from_json recipe_json
          num_videos = recipe.videos.count
          view_recipe = Views::Recipe.new(recipe)
          view 'recipe', locals: { recipe: view_recipe, num_videos: num_videos }
        end

        # # /recipe/all branch
        routing.on 'all' do
          # GET # /recipe/all request
          routing.get do
            recipes_json = ApiGateway.new.all_recipes.message
            all_recipes = RecipeBuddy::RecipesRepresenter.new(OpenStruct.new)
                                                         .from_json recipes_json

            view_recipes = Views::AllRecipes.new(all_recipes)
            title = 'All the recipes available'
            view 'recipes', locals: { recipes: view_recipes, title: title }
          end
        end
      end

      # # /recipe branch
      routing.on 'loaded_recipe' do
        # GET # /recipe/loaded_recipe/:recipe_id request
        routing.is Integer do |recipe_id|
          # GET /api/v0.1/loaded_recipe/:recipe_id request
          recipe_json = ApiGateway.new.get_recipe(recipe_id).message
          recipe = RecipeBuddy::RecipeRepresenter.new(OpenStruct.new)
                                                 .from_json recipe_json
          view_recipe = Views::Recipe.new(recipe)

          Slim::Engine.with_options(pretty: true) do
            render :recipe_card, locals: { recipe: view_recipe }, layout: false
          end
        end
      end
    end
  end
end
