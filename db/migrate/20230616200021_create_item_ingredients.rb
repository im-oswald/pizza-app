class CreateItemIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :item_ingredients do |t|
      t.references :item, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.string :ingredient_type, null: false

      t.timestamps
    end

    add_index :item_ingredients, %i[ingredient_id item_id], unique: true
  end
end
