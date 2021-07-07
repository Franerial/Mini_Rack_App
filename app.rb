# frozen_string_literal: true

require_relative 'services/time_converter'

class App
  def call(env)
    @request = Rack::Request.new(env)

    result = TimeConverter.new(@request.params['format']).call
    @response = if result.success?
                  Rack::Response.new(result.body, 200)
                else
                  Rack::Response.new(result.body, 400)
                end

    @response.finish
  end
end
