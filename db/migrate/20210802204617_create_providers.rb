class CreateProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :providers do |t|
      t.string :npi
      t.string :name
      t.string :address
      t.string :telephone_number
      t.boolean :organization
      t.timestamps
    end
  end
end
