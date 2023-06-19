# frozen_string_literal: true

namespace :db do
  desc 'Truncate all tables in the database'
  task truncate: :environment do
    Rails.logger = Logger.new($stdout)

    connection = ActiveRecord::Base.connection
    tables = connection.tables - %w[schema_migrations]

    tables.each do |table|
      connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE;")
    end

    Rails.logger.debug { 'All tables truncated.' }
  end
end
