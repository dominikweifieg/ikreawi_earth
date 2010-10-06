class LegacySetQuestion < ActiveRecord::Base
  establish_connection :legacy 
  set_table_name "tx_wintestsuite_set_questions_mm"
  self.inheritance_column = ""
  
  belongs_to :legacy_set, :foreign_key => :uid_local, :primary_key => :uid
  belongs_to :legacy_question, :foreign_key => :uid_foreign, :primary_key => :uid
end
