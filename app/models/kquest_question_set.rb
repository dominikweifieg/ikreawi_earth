class KquestQuestionSet < ActiveRecord::Base
  establish_connection :kquest
  
  set_table_name "fragenset"
  set_primary_key "set_id"
  self.inheritance_column = ""
  
  has_many :kquest_links, :foreign_key => :setId, :primary_key => :questset_id
  has_many :kquest_questions, :through => :kquest_links
end
