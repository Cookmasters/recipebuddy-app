# frozen_string_literal: true

class HomePage
  include PageObject

  page_url RecipeBuddy::App.config.APP_URL

  text_field(:page_url, id: 'page_url_input')
  button(:add_button, id: 'page_form_submit')
  div(:main_header, id: 'main_header')
  div(:flash_bar_success, id: 'flash_bar_success')
  div(:flash_bar_danger, id: 'flash_bar_danger')
  div(:recipes_div, id: 'recipes_div')

  def add_new_page(facebook_url)
    self.page_url = facebook_url
    add_button
  end
end
