# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Homepage' do
  before do
    unless @browser
      RecipeBuddy::ApiGateway.new.delete_all_pages
      # @headless = Headless.new
      @browser = Watir::Browser.new
      @browser.goto 'http://localhost:9292'
    end
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Empty Homepage' do
    it '(HAPPY) should see no content' do
      # GIVEN: user is on the home page without any projects
      # @browser.goto homepage

      # THEN: user should see basic headers, no projects and a welcome message
      _(@browser.text_field(name: 'url').visible?).must_equal true
      _(@browser.div(id: 'flash_bar_success').visible?).must_equal true
      _(@browser.div(id: 'flash_bar_success').text).must_include 'Add'
      _(@browser.text_field(id: 'url_input').visible?).must_equal true
      _(@browser.button(id: 'page_form_submit').visible?).must_equal true
    end
  end

  describe 'Add new project' do
    it '(BAD) should not accept incorrect URL' do
      @browser.text_field(id: 'input').set('http://bad_url')
      @browser.button(id: 'page_form_submit').click

      _(@browser.div(id: 'flash_bar_danger').text).must_include 'Invalid'
    end
  end
end
