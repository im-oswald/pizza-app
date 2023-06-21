# frozen_string_literal: true

orders_data = YAML.load_file(Rails.root.join('lib/data/orders.yml'))

OrderCreationService.call(orders_data)
