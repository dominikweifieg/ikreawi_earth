class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :title
      t.string :short_title
      t.text :description
      t.string :identifier
      t.integer :old_uid
      t.boolean :original_pruefung
      
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
