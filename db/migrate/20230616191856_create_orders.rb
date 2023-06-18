class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'uuid-ossp'
    create_table :orders do |t|
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.string :status, default: 'open'
      t.references :discount_code, foreign_key: true

      t.index :uuid, unique: true

      t.timestamps
    end
  end
end
