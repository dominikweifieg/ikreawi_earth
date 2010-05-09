class LegacyCategoriesController < ApplicationController
  before_filter :logged_in?
  
  def index
    @categories = LegacyCategory.all();
  end

  def show
    @category = LegacyCategory.find_by_uid(params[:id])
    @imported = Category.exists?(:old_uid => params[:id])
    
    if(params[:import].present?)
      import(@category, @imported)
      redirect_to categories_path
    end
  end

  private 
  def import(legacy_category, reimport)
    if(reimport)
      category = Category.find_by_old_uid(@category.uid)
      category.destroy
    end
    category = Category.new(:title => legacy_category.title, :description => legacy_category.description, 
      :old_uid => legacy_category.uid, :identifier => "de.kreawi.ikreawi.#{legacy_category.title.parameterize('_')}".sub(/-/, "_"))
    category.original_pruefung = legacy_category.title =~ /Prüfung/
    
    legacy_category.legacy_questions.each do |legacy_question|
      question = Question.new do |q|
        body = legacy_question.question
        if(legacy_question.questiontype == 2)
          body << "\t\t<ol>"
          body << "\t\t\t<li>#{legacy_question.kombianswer_1}</li>" unless legacy_question.kombianswer_1.empty?
          body << "\t\t\t<li>#{legacy_question.kombianswer_2}</li>" unless legacy_question.kombianswer_2.empty?
          body << "\t\t\t<li>#{legacy_question.kombianswer_3}</li>" unless legacy_question.kombianswer_3.empty?
          body << "\t\t\t<li>#{legacy_question.kombianswer_4}</li>" unless legacy_question.kombianswer_4.empty?
          body << "\t\t\t<li>#{legacy_question.kombianswer_5}</li>" unless legacy_question.kombianswer_5.empty?
          body << "\t\t\t<li>#{legacy_question.kombianswer_6}</li>" unless legacy_question.kombianswer_6.empty?
          body << "\t\t\t<li>#{legacy_question.kombianswer_7}</li>" unless legacy_question.kombianswer_7.empty?
          body << "\t\t\t<li>#{legacy_question.kombianswer_8}</li>" unless legacy_question.kombianswer_8.empty?
          body << "\t\t\t<li>#{legacy_question.kombianswer_9}</li>" unless legacy_question.kombianswer_9.empty?
          body << "\t\t\t<li>#{legacy_question.kombianswer_10}</li>" unless legacy_question.kombianswer_10.empty?
          body << "\t\t</ol>"
        end
        q.body = body
        q.comment = legacy_question.commentedanswer
      end
      category.questions << question
      question.save
      unless(legacy_question.questiontype == 3)
        a1 = Answer.new(:body => legacy_question.answer_a, :correct => (legacy_question.correct_answers | 1 == legacy_question.correct_answers))
        question.answers << a1
        a1.save
        a2 = Answer.new(:body => legacy_question.answer_b, :correct => (legacy_question.correct_answers | 2 == legacy_question.correct_answers))
        question.answers << a2
        a2.save
        a3 = Answer.new(:body => legacy_question.answer_c, :correct => (legacy_question.correct_answers | 4 == legacy_question.correct_answers))
        question.answers << a3
        a3.save
        a4 = Answer.new(:body => legacy_question.answer_d, :correct => (legacy_question.correct_answers | 8 == legacy_question.correct_answers))
        question.answers << a4
        a4.save
        a5 = Answer.new(:body => legacy_question.answer_e, :correct => (legacy_question.correct_answers | 16 == legacy_question.correct_answers))
        question.answers << a5
        a5.save
      end
    end
    category.save
  end

end
