class Category < ActiveRecord::Base
  has_many :questions, :dependent => :destroy, :order => :id
  
  def self.updated_since(date)
    logger.info("updated_since #{date}")
    Category.find(:all, :conditions => ["updated_at > :date", {:date => date} ])
  end
end
