class LegacySet < ActiveRecord::Base
  establish_connection :legacy 
  set_table_name "tx_wintestsuite_set"
  set_primary_key "uid"
  self.inheritance_column = ""
  
  has_many :legacy_set_questions, :foreign_key => :uid_local, :primary_key => :uid
  has_many :legacy_questions, -> { where("deleted = 0") }, :through => :legacy_set_questions
  
  def primary_key
    "uid"
  end
  
  def to_param
    "#{uid}"
  end
end
