# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Homepage' do
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
    it '(HAPPY) should see no content' do
      # GIVEN: user is on the home page without any recipes
      @browser.goto homepage

      # THEN: user should see basic headers, no recipes and a welcome message
      _(@browser.div(id: 'main_header').text).must_equal 'RecipeBuddy'
      _(@browser.text_field(name: 'page_url').visible?).must_equal true
      _(@browser.div(id: 'flash_bar_success').visible?).must_equal true
      _(@browser.div(id: 'flash_bar_success').text).must_include 'Add'
      _(@browser.text_field(id: 'page_url_input').visible?).must_equal true
      _(@browser.button(id: 'page_form_submit').visible?).must_equal true
    end
  end

  # describe 'Add new Facebook page' do
  #   it '(BAD) should not accept incorrect URL' do
  #     @browser.text_field(id: 'page_url_input').set('olcooker')
  #     @browser.button(id: 'page_form_submit').click
  #
  #     _(@browser.div(id: 'flash_bar_danger').text).must_include 'Invalid'
  #   end
  # end

  describe 'Add new facebook page' do
    it '(HAPPY) should add valid Facebook page' do
      # GIVEN: user is on the home page
      @browser.goto homepage

      # WHEN: user enters a valid Page name to get the recipes
      @browser.text_field(id: 'page_url_input')
              .set('https://www.facebook.com/RecipesAndCookingGuide')
      @browser.button(id: 'page_form_submit').click
      _(@browser.div(id: 'flash_bar_success').text).must_include 'added'
      _(@browser.div(id: 'flash_bar_danger').exists?).must_equal false

      # THEN: user should see the recipes of their new page listed in a div
      # table = @browser.table(id: 'repos_table')
      _(@browser.div(id: 'recipes_div').exists?).must_equal true
      #
      # row = table.rows[1]
      # _(table.rows.count).must_equal 2
      # _(row.td(id: 'td_owner').text).must_equal 'soumyaray'
      # _(row.td(id: 'td_repo_name').text).must_equal 'YPBT-app'
      # _(row.td(id: 'td_link').text).include? 'https'
      # _(row.td(id: 'td_contributors').text.split(', ').count).must_equal 3
    end

    it '(BAD) should not accept incorrect URL' do
      # GIVEN: user is on the home page
      @browser.goto homepage

      # WHEN: user does not enter a page name
      @browser.text_field(id: 'page_url_input').set('')
      @browser.button(id: 'page_form_submit').click

      # THEN: user should see an error alert that the page name must be filled
      _(@browser.div(id: 'flash_bar_danger').text).must_equal 'must be filled'

      # WHEN: user enters a page which posts do not relate to recipes
      @browser.text_field(id: 'page_url_input')
              .set('https://www.facebook.com/thepracticaldev/')
      @browser.button(id: 'page_form_submit').click

      # THEN: user should should see an error alert
      _(@browser.div(id: 'flash_bar_danger').text).must_include 'enough recipes'
    end

    it '(SAD) should not accept duplicate page' do
      # GIVEN: user is on the home page
      @browser.goto homepage

      # WHEN: user enters a page name that was previously loaded
      @browser.text_field(id: 'page_url_input')
              .set('https://www.facebook.com/RecipesAndCookingGuide')
      @browser.button(id: 'page_form_submit').click
      @browser.text_field(id: 'page_url_input')
              .set('https://www.facebook.com/RecipesAndCookingGuide')
      @browser.button(id: 'page_form_submit').click

      # THEN: user should should see an error alert and the existing page
      _(@browser.div(id: 'flash_bar_danger').text).must_include 'already loaded'
      _(@browser.div(id: 'recipes_div').visible?).must_equal true
      # _(@browser.table(id: 'repos_table').rows.count).must_equal 2
    end
  end
end
