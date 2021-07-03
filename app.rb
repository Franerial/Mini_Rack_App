# frozen_string_literal: true

require_relative "services/time_converter"

class App
  AVAILABLE_PATH = "/time"
  AVAILABLE_PARAM = "format"
  ACCEPTABLE_FORMAT = %w[year month day hour minute second].freeze

  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new(body, status)

    @response.finish
  end

  private

  def status
    if @request.path_info == AVAILABLE_PATH && acceptably? && @request.get?
      200
    elsif @request.path_info == AVAILABLE_PATH && @request.get? && correct_param_name?
      400
    else
      404
    end
  end

  def body
    if @request.path_info == AVAILABLE_PATH && acceptably? && @request.get?
      result = TimeConverter.new(@request).call
      result.success? ? result.data : ["Not found"]
    elsif @request.path_info == AVAILABLE_PATH && correct_param_name? && @request.get?
      ["Unknown time format #{unknown_time_format}"]
    else
      ["Not found"]
    end
  end

  def acceptably?
    (@request.params["format"].split(",") - ACCEPTABLE_FORMAT).empty? if correct_param_name?
  end

  def correct_param_name?
    @request.params.keys.first == AVAILABLE_PARAM
  end

  def unknown_time_format
    @request.params["format"].split(",") - ACCEPTABLE_FORMAT
  end
end
