class CreateProvinces < ActiveRecord::Migration[7.2]
  def change
    create_table :provinces do |t|
      t.string :name, null: false
      t.string :abbreviation, null: false
      t.decimal :gst_rate, precision: 5, scale: 4, null: false, default: 0.0
      t.decimal :pst_rate, precision: 5, scale: 4, null: false, default: 0.0
      t.decimal :hst_rate, precision: 5, scale: 4, null: false, default: 0.0

      t.timestamps
    end
    add_index :provinces, :name, unique: true
    add_index :provinces, :abbreviation, unique: true
  end
end