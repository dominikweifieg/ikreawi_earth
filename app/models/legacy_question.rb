class LegacyQuestion < ActiveRecord::Base
  establish_connection :legacy 
  set_table_name "tx_wintestsuite_questions"
  set_primary_key "uid"
  self.inheritance_column = ""
  
  has_many :legacy_category_questions, :foreign_key => "uid_local"
  has_many :legacy_categories, :through => :legacy_category_questions
  
  def primary_key
    "uid"
  end
  
  def to_param
    "#{uid}"
  end
end
