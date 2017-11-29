# frozen_string_literal: true

require_relative 'spec_helper'
require 'econfig'

describe 'Homepage' do
  extend Econfig::Shortcut

  Econfig.env = 'development'
  Econfig.root = '.'

  before do
    unless @browser
      RecipeBuddy::ApiGateway.new.delete_all_recipes
      # @headless = Headless.new
      @browser = Watir::Browser.new
    end
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Empty Homepage' do
    include PageObject::PageFactory

    it '(HAPPY) should see no content' do
      # GIVEN: user is on the home page without any recipes
      visit HomePage do |page|
        # THEN: user should see basic headers, no recipes and a welcome message
        _(page.main_header_element.text).must_equal 'RecipeBuddy'
        _(page.page_url_element.visible?).must_equal true
        _(page.flash_bar_success_element.visible?).must_equal true
        _(page.flash_bar_success_element.text).must_include 'Add'
        _(page.page_url_element.visible?).must_equal true
        _(page.add_button_element.visible?).must_equal true
      end
    end
  end

  describe 'Add new facebook pages' do
    include PageObject::PageFactory

    it '(HAPPY) should add Facebook page with valid URL' do
      # GIVEN: user is on the home page
      visit HomePage do |page|
        # WHEN: user enters a valid Facebook page URL to get the recipes
        page.add_new_page 'https://www.facebook.com/RecipesAndCookingGuide'

        # THEN: user should see a success flash bar and the recipes div
        _(page.flash_bar_success_element.text).must_include 'added'
        _(page.flash_bar_danger_element.exists?).must_equal false
        _(page.recipes_div_element.exists?).must_equal true
      end
    end

    it 'HAPPY: should be able to add multiple Facebook pages' do
      # GIVEN: on the homepage
      visit HomePage do |page|
        # WHEN: user enters a valid URL for two new pages
        page.add_new_page 'https://www.facebook.com/RecipesAndCookingGuide'
        page.navigate_to app.config.APP_URL
        page.add_new_page 'https://www.facebook.com/easyrecipesly'

        # THEN: user should see both new repos listed in a table
        _(page.recipes_div_element.exists?).must_equal true
      end
    end

    it '(BAD) should not accept incorrect URL' do
      # GIVEN: user is on the home page
      visit HomePage do |page|
        # WHEN: user does not enter a page name
        page.add_new_page ''

        # THEN: user should see an error alert that the page name must be filled
        _(page.flash_bar_danger_element.exists?).must_equal true
        _(page.flash_bar_danger_element.text).must_equal 'must be filled'

        # WHEN: user enters a page which posts do not relate to recipes
        page.add_new_page 'https://www.facebook.com/thepracticaldev/'

        # THEN: user should should see an error alert
        _(page.flash_bar_danger_element.text).must_include 'enough recipes'
      end
    end

    it '(SAD) should not accept duplicate page' do
      # GIVEN: user is on the home page
      visit HomePage do |page|
        # WHEN: user enters a page URL that was previously loaded
        page.add_new_page 'https://www.facebook.com/RecipesAndCookingGuide'
        page.navigate_to app.config.APP_URL
        page.add_new_page 'https://www.facebook.com/RecipesAndCookingGuide'

        # THEN: user should should see an error alert and the existing page
        _(page.flash_bar_danger_element.text).must_include 'already loaded'
        _(page.recipes_div_element.visible?).must_equal true
      end
    end
  end
end
