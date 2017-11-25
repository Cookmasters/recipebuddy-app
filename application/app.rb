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
        recipes_json = ApiGateway.new.all_recipes
        all_recipes = RecipeBuddy::RecipesRepresenter.new(OpenStruct.new)
                                                     .from_json recipes_json

        recipes = Views::AllRecipes.new(all_recipes)
        if recipes.none?
          flash.now[:notice] = 'Add a Facebook public page/group to get started'
        end
        view 'home', locals: { recipes: recipes }
      end

      routing.on 'page' do
        routing.post do
          create_request = Forms::FacebookNameValidator.call(routing.params)
          result = AddPage.new.call(create_request)

          if result.success?
            flash[:notice] = 'New Facebook Page/group added!'
          else
            flash[:error] = result.value
          end

          routing.redirect '/'
        end
      end
    end
  end
end
