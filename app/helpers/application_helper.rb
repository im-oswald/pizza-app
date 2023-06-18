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
end
