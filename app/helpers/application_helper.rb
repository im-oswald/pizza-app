# frozen_string_literal: true

module ApplicationHelper
  def format_timestamp(timestamp)
    # Format the time as a human-readable string
    timestamp.strftime('%B %d, %Y %H:%M')
  end

  def format_amount(decimal)
    # Format the amount to be 2 digits after decimal point
    format('%.2f', decimal)
  end

  def flash_class(type)
    case type
    when 'success'
      'bg-green-500 text-white px-4 py-2 rounded'
    when 'error'
      'bg-red-500 text-white px-4 py-2 rounded'
    when 'alert'
      'bg-yellow-500 text-white px-4 py-2 rounded'
    else
      'bg-blue-500 text-white px-4 py-2 rounded'
    end
  end
end
