class CreateItemIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :item_ingredients do |t|
      t.references :item, null: false, foreign_key: true
      t.references :ingredient, null: false, polymorphic: true

      t.timestamps
    end

    add_index :item_ingredients, [:ingredient_type, :ingredient_id]
  end
end
