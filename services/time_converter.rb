# frozen_string_literal: true

class TimeConverter
  AVAILABLE_PATH = "/time"
  ACCEPTABLE_FORMAT = %w[year month day hour minute second].freeze
  TIME_CONVERT_FORMATS = {
    "year" => "%Y",
    "month" => "%m",
    "day" => "%d",
    "hour" => "%H",
    "minute" => "%M",
    "second" => "%S",
  }.freeze

  Result = Struct.new(:body) do
    def success?
      body.first.include? "-"
    end

    def contain_unknown_params?
      body.first.include? "Unknown params"
    end
  end

  def initialize(request)
    @request = request
  end

  def call
    if valid_input_data? && acceptably?
      Result.new([convert_user_format])
    elsif contain_unknown_params?
      Result.new(["Unknown params #{unknown_time_format}"])
    else
      Result.new(["Not found"])
    end
  end

  private

  def valid_input_data?
    @request.path_info == AVAILABLE_PATH && correct_param_name? && @request.get?
  end

  def contain_unknown_params?
    valid_input_data? && unknown_time_format.any?
  end

  def correct_param_name?
    !@request.params["format"].nil?
  end

  def acceptably?
    (@request.params["format"].split(",") - ACCEPTABLE_FORMAT).empty? if correct_param_name?
  end

  def unknown_time_format
    @request.params["format"].split(",") - ACCEPTABLE_FORMAT
  end

  def convert_user_format
    display_format = @request.params["format"].split(",").reduce("") do |sum, param|
      "#{sum}#{TIME_CONVERT_FORMATS[param]}-"
    end.chop

    Time.now.strftime(display_format)
  end
end
