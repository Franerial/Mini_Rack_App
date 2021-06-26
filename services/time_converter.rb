# frozen_string_literal: true

class TimeConverter
  AVAILABLE_PATH = '/time'
  AVAILABLE_PARAM = 'format'
  ACCEPTABLE_FORMAT = %w[year month day hour minute second].freeze
  TIME_CONVERT_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(request)
    @request = request
  end

  def call
    [body, status]
  end

  def status
    if @request.path_info == AVAILABLE_PATH && acceptably? && @request.get?
      200
    elsif @request.path_info == AVAILABLE_PATH && @request.get?
      400
    else
      404
    end
  end

  def body
    if @request.path_info == AVAILABLE_PATH && correct_param_name? && acceptably? && @request.get?
      [convert_user_format]
    elsif @request.path_info == AVAILABLE_PATH && correct_param_name? && @request.get?
      ["Unknown time format #{unknown_time_format}"]
    else
      ['Not found']
    end
  end

  def acceptably?
    (@request.params['format'].split(',') - ACCEPTABLE_FORMAT).empty? if @request.params['format']
  end

  def correct_param_name?
    @request.params.keys.first == AVAILABLE_PARAM
  end

  def unknown_time_format
    @request.params['format'].split(',') - ACCEPTABLE_FORMAT
  end

  def convert_user_format
    display_format = @request.params['format'].split(',').reduce('') do |sum, param|
      "#{sum}#{TIME_CONVERT_FORMATS[param]}-"
    end.chop

    Time.now.strftime(display_format)
  end
end
