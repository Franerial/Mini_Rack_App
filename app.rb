# frozen_string_literal: true

require_relative 'services/time_converter'

class App
  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new(*create_response_data)

    @response.finish
  end

  private

  def create_response_data
    converter = TimeConverter.new(@request)
    converter.call
  end
end
