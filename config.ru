# frozen_string_literal: true

require_relative 'app'

use Rack::ContentType, 'text/plain'
run Rack::URLMap.new({ '/time' => App.new })
