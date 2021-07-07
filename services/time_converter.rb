# frozen_string_literal: true

class TimeConverter
  TIME_CONVERT_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  Result = Struct.new(:body) do
    def success?
      body.include? '-'
    end
  end

  def initialize(data)
    @data = data
  end

  def call
    if !@data.nil?
      return Result.new(convert_user_format) if valid_input_data?

      Result.new("Unknown time format #{unknown_time_format}")
    else
      Result.new('Invalid param name')
    end
  end

  private

  def valid_input_data?
    (@data.split(',') - TIME_CONVERT_FORMATS.keys).empty?
  end

  def unknown_time_format
    @data.split(',') - TIME_CONVERT_FORMATS.keys
  end

  def convert_user_format
    display_format = @data.split(',').reduce('') do |sum, param|
      "#{sum}#{TIME_CONVERT_FORMATS[param]}-"
    end.chop

    Time.now.strftime(display_format)
  end
end
