class TrainerLicense < ActiveRecord::Base

  validates_uniqueness_of :email, :scope => [:computer_name, :license]

  def self.find_registrations(license, email, computer_name)
    TrainerLicense.find(:all, :conditions => ["license = :license AND computer_name = :computer_name", {:license => license, :computer_name => computer_name} ])
  end

end
