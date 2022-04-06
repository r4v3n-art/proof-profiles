class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :eth_address
      t.index :eth_address, unique: true
      t.text :bio

      t.timestamps
    end
  end
end
