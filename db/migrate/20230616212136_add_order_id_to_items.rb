class AddOrderIdToItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :order, foreign_key: true
  end
end
