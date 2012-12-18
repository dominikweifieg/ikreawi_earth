class CategoriesController < ApplicationController
  require 'imobile'
  
    before_filter :logged_in?, :except => [:show, :index, :fetch, :initial]
    before_filter :check_access, :only => [:show, :index]
    protect_from_forgery :except => :fetch
  
  # GET /categories
  # GET /categories.xml
  def index
    app_name = params[:app_name]
    app_name = "iKreawi" unless app_name
    if params[:updated_after].present?
      @categories = Category.updated_since(params[:updated_after], app_name)
      @token = daily_token
    elsif params[:original_questions].present?
      @categories = Category.find(:all, :conditions => ["original_pruefung = :original_pruefung AND app_name = :app_name", {:original_pruefung => params[:original_questions], :app_name => app_name}])
    elsif params[:type_id].present?
      @categories = Category.find(:all, :conditions => ["type_id = :type_id AND app_name = :app_name", {:type_id => params[:type_id], :app_name => app_name}])
    else
      case request.format
      when Mime::JSON
        @categories = Category.find(:all, :conditions => ["app_name = :app_name", {:app_name => app_name}])
      else
        @categories = Category.all
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
      format.plist
      format.json { render :json => @categories.to_json()}#:include => {:questions => {:include => :answers }})}
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    if @receipt
      product_id = @receipt[:product_id]
      product_id = product_id.delete "medizinfragen."
      @category = Category.find_by_identifier(product_id)
    elsif params[:product_id].present?
      product_id = params[:product_id]
      product_id = product_id.delete "medizinfragen."
      @category = Category.find_by_identifier(product_id)
    else
      @category = Category.find(params[:id])
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml 
      format.plist 
      format.json { render :json => @category.to_json(:include => {:questions => {:include => :answers }})}
    end
  end
  
  def initial
    app_name = params[:app_name]
    app_name = "iKreawi" unless app_name
    @category = Category.find(:first, :conditions => ["original_pruefung = :original_pruefung AND app_name = :app_name", {:original_pruefung => true, :app_name => app_name}], :order => "created_at DESC")
    render :text => @category.identifier
  end
  
  def fetch
    receipt_data = Base64.decode64(params[:transaction_receipt])
    logger.error receipt_data
    check_itunes_receipt(receipt_data)
    if @receipt
      logger.error @receipt
      logger.error @receipt[:product_id]
      @category = Category.find_by_identifier(@receipt[:product_id])
      
      respond_to do |format|
        format.plist 
      end
    else
      logger.error "FOO!"
      render :text => "Not allowed!"
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    if params[:copy_cat].present?
      copy_cat = Category.find(params[:copy_cat])
      
      @category = Category.new(copy_cat.attributes.merge(:old_uid => nil))
      
      copy_cat.questions.each do |copy_q|
        question = Question.new(copy_q.attributes)
        @category.questions << question
        copy_q.answers.each do |copy_a|
          answer = Answer.new(copy_a.attributes)
          question.answers << answer
        end
      end
    else
      @category = Category.new(params[:category])
    end
    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(@category) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(@category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end
  
  private 
  def check_access
    respond_to do |format|
      format.html do
        logged_in?
      end
      format.xml do 
        #logged_in? unless request.headers["producer"] == "android"
      end
      format.json do
        #OK
      end
      format.plist do
        if params[:transaction_receipt].present?
          check_itunes_receipt params[:transaction_receipt]
        elsif params[:initial].present?
          #OK
        elsif params[:token].present? && params[:token] == daily_token
          #OK
        elsif params[:updated_after].present?
          #OK
        elsif params[:original_questions].present?
          #OK
        elsif params[:type_id].present?
          #OK
        else
          render :text => "Not authorized"
        end
      end
    end
  end
  
  def check_itunes_receipt(receipt)
    if(params[:sandbox].present?)
      @receipt = Imobile.validate_receipt(receipt, :sandbox)
    else
      @receipt = Imobile.validate_receipt(receipt, :production)
    end
    logger.info "receipt: #{@receipt}"
    @receipt
  end
  
  def daily_token
    Date.new.to_s.hash.to_s(36)
  end
end
