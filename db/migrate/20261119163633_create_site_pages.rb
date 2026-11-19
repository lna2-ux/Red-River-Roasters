class CreateSitePages < ActiveRecord::Migration[7.2]
  def change
    create_table :site_pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body, null: false

      t.timestamps
    end
    add_index :site_pages, :slug, unique: true
  end
end