class CreateTrainerLicenses < ActiveRecord::Migration
  def self.up
    create_table :trainer_licenses do |t|
      t.string :license
      t.string :email
      t.string :computer_name
      t.boolean :rejected, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :trainer_licenses
  end
end
