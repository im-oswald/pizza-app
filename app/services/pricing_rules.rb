# frozen_string_literal: true

module PricingRules
  def self.load_rules
    YAML.load_file(Rails.root.join('config/rules/pricing.yml'))
  end
end
