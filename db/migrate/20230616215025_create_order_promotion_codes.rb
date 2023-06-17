class CreateOrderPromotionCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :order_promotion_codes, id: false do |t|
      t.references :order, null: false, foreign_key: true
      t.references :promotion_code, null: false, foreign_key: true

      t.timestamps
    end

    add_index :order_promotion_codes, [:order_id, :promotion_code_id], unique: true
  end
end
