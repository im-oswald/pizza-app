# frozen_string_literal: true

module ApplicationHelper
  def format_timestamp(timestamp)
    # Convert the timestamp to a Time object
    time = Time.at.utc(timestamp)

    # Format the time as a human-readable string
    time.strftime('%B %d, %Y %H:%M')
  end
end
