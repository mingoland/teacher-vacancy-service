module DateHelper
  class FormatDateError < RuntimeError; end

  def format_date(date, format = :default)
    return 'No date given' if date.nil?
    date_formats = Date::DATE_FORMATS.keys.join(' ')
    raise FormatDateError, date_format_error_message(format, date_formats) unless Date::DATE_FORMATS.include?(format)
    date.to_s(format).lstrip
  end

  def date_format_error_message(format, date_formats)
    "Unknown format: #{format} should be one of #{date_formats}"
  end
end
