# frozen_string_literal: true

require_relative 'app'

use Rack::ContentType, 'text/plain'
run App.new
