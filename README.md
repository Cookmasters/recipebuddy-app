# RecipeBuddy APP

[ ![Codeship Status for Cookmasters/recipebuddy-app](https://app.codeship.com/projects/0c713c00-caf6-0135-edf9-223ddcc20f61/status?branch=master)](https://app.codeship.com/projects/261818)

This is our Service Oriented Architecture Web Application and aims to add recipes for Facebook public pages and find the relevant videos of the recipes from YouTube. This Application interacts with our API that you can find [here](https://github.com/Cookmasters/recipebuddy-api)

## Routes

### Application Routes

- GET `/`: main route. Displays the TOP 150 best recipes


### Page Routes

- GET `page/all`: returns all the Facebook pages along with the recipes already saved in the database
- GET `page/[pagename]`: returns the page information along with the recipes of that page
- POST `page`: adds the Facebook page to the database

### Recipe Routes

- GET `recipe/[id]`: returns the details of a recipe
- GET `recipe/all`: returns a json of all the recipes already saved in the database
- GET `loaded_recipe/[id]`: returns an html of the recipe card.


## Install

Install this APP by cloning the *relevant branch* and installing required gems:

    $ git clone git@github.com:Cookmasters/recipebuddy-app.git
    $ cd recipebuddy-app
    $ bundle install

You may have to add your session secret to `config/secrets.yml` (see example in folder).

## Testing

Test this APP by running:

    $ bundle exec rake spec

## Develop

Run this APP during development:

    $ bundle exec rake run:dev

## Rake tasks available

Run the following task to find more Rake tasks:

    $ rake -T
