class CreateDiscountCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :discount_codes do |t|
      t.string :code, null: false

      t.timestamps
    end

    add_index :discount_codes, :code, unique: true
  end
end
