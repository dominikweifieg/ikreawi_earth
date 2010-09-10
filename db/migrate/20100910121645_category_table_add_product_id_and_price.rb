class CategoryTableAddProductIdAndPrice < ActiveRecord::Migration
  def self.up
    add_column :categories, :app_name, :string, :default => "iKreawi"
    add_column :categories, :price, :string, :default => ""
  end

  def self.down
    remove_column :categories, :price
    remove_column :categories, :app_name
  end
end
