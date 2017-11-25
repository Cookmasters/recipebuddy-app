# frozen_string_literal: false

require_relative 'app.rb'

folders = %w[representers forms services views]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
