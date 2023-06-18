require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_presence_of(:size) }
  end

  describe "associations" do
    it { should belong_to(:order) }
    it { should have_many(:item_ingredients).dependent(:destroy) }
    it { should have_many(:add_ingredients).through(:item_ingredients).source(:ingredient) }
    it { should have_many(:remove_ingredients).through(:item_ingredients).source(:ingredient) }
  end
end
