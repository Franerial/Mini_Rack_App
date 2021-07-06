# frozen_string_literal: true

class TimeConverter
  ACCEPTABLE_FORMAT = %w[year month day hour minute second].freeze
  AVAILABLE_TIME_FORMATS = %w[%Y %m %d %H %M %S].freeze
  TIME_CONVERT_FORMATS = Hash[ACCEPTABLE_FORMAT.zip AVAILABLE_TIME_FORMATS].freeze

  Result = Struct.new(:body) do
    def success?
      body.first.include? "-"
    end
  end

  def initialize(request)
    @request = request
  end

  def call
    return Result.new([convert_user_format]) if valid_input_data? && acceptably?
    return Result.new(["Unknown time format #{unknown_time_format}"]) if contain_unknown_params?
    Result.new(["Undefined params #{@request.params.keys}"])
  end

  private

  def valid_input_data?
    correct_param_name? && @request.get?
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
