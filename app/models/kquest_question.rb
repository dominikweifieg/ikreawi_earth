class KquestQuestion < ActiveRecord::Base
  establish_connection :kquest 
  set_table_name "questions"
  set_primary_key "uid"
  self.inheritance_column = ""
  
  has_many :kquest_links, :foreign_key => "questID"
  has_many :kquest_question_sets, :through => :kquest_links
  
  def primary_key
    "uid"
  end
  
  def to_param
    "#{uid}"
  end
end