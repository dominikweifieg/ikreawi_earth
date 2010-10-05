class RemovePriceFromCategries < ActiveRecord::Migration
  def self.up
    remove_column :categories, :price
    add_column :categories, :type_id, :integer, :default => "0"
  end

  def self.down
    remove_column :categories, :type_id
    add_column :categories, :price, :string,             :default => ""
  end
end
