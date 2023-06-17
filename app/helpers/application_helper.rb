# frozen_string_literal: true

module ApplicationHelper
  def format_timestamp(timestamp)
    # Format the time as a human-readable string
    timestamp.strftime('%B %d, %Y %H:%M')
  end
end
