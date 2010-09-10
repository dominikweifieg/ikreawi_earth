class Category < ActiveRecord::Base
  has_many :questions, :dependent => :destroy, :order => :id
  
  def self.updated_since(date, app_name)
    logger.info("updated_since #{date}")
    Category.find(:all, :conditions => ["updated_at > :date AND app_name = :app_name", {:date => date, :app_name => app_name} ])
  end
end
