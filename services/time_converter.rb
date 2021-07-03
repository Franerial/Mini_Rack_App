# frozen_string_literal: true

class TimeConverter
  TIME_CONVERT_FORMATS = {
    "year" => "%Y",
    "month" => "%m",
    "day" => "%d",
    "hour" => "%H",
    "minute" => "%M",
    "second" => "%S",
  }.freeze

  Result = Struct.new(:data) do
    def success?
      !data.nil?
    end
  end

  def initialize(request)
    @request = request
  end

  def call
    if @request.params["format"]
      display_format = @request.params["format"].split(",").reduce("") do |sum, param|
        "#{sum}#{TIME_CONVERT_FORMATS[param]}-"
      end.chop
      Result.new(Time.now.strftime(display_format))
    else
      Result.new
    end
  end
end
