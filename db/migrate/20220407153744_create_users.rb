class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :eth_address, null: false
      t.text :bio

      t.index :eth_address, unique: true

      t.timestamps
    end
  end
end
