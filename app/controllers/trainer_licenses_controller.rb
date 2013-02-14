class TrainerLicensesController < ApplicationController
  # GET /trainer_licenses
  # GET /trainer_licenses.xml
  def index
    if(params[:license].present?)
      @trainer_licenses = TrainerLicense.find_all_by_license(params[:license])
      if(params[:license].empty?)
        @empty_lic = true
      else
        @empty_lic = false
      end
    else
      @empty_lic = true
      @trainer_licenses = TrainerLicense.all(:order => "license ASC")
      @all_licenses = @trainer_licenses
    end
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trainer_licenses }
      format.json do
        if @trainer_licenses.count == 0
          render :text => "NOT_FOUND"
        elsif @trainer_licenses.count < 3
          registered = false
          rejected = false
          @trainer_licenses.each do |license|
            if license.computer_name == params[:computer_name]
              registered = true
              if license.rejected?
                rejected = true
              end
            end
          end
          if registered
            if rejected
              render :text => "REJECTED"
            else
              render :text => "OK"
            end
          else
             render :text => "NOT_FOUND"
           end
        else
          if @empty_lic
            render :text => "OK"
          else
           rejected = false
           found = false
           @trainer_licenses.each do |license|
             if license.computer_name == params[:computer_name]
               found = true
               if license.rejected?
                 rejected = true
               end
             end
           end
           if found
             if rejected
               render :text => "REJECTED"
             else
               render :text => "DUPLICATE"
             end
           else
             render :text => "NOT_FOUND"
           end
         end
         end
       end
    end
  end

  # GET /trainer_licenses/1
  # GET /trainer_licenses/1.xml
  def show
    @trainer_license = TrainerLicense.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trainer_license }
    end
  end

  # GET /trainer_licenses/new
  # GET /trainer_licenses/new.xml
  def new
    @trainer_license = TrainerLicense.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trainer_license }
    end
  end

  # GET /trainer_licenses/1/edit
  def edit
    @trainer_license = TrainerLicense.find(params[:id])
  end

  # POST /trainer_licenses
  # POST /trainer_licenses.xml
  def create
    @trainer_license = TrainerLicense.new(params[:trainer_license])

    saved = @trainer_license.save
    
    if saved
      unless(params[:trainer_license][:license].present? || params[:trainer_license][:license].empty?)
       @trainer_licenses = TrainerLicense.find(:all, :conditions => ["license = :license", {:license => params[:trainer_license][:license]}], :order => "created_at DESC");
      if @trainer_licenses.count > 2
        @trainer_licenses.each_with_index do | license, index |
          if index > 2
            license.rejected = true
            license.save
          end
        end
      end
    end
    end

    respond_to do |format|
      if saved
        format.html { redirect_to(@trainer_license, :notice => 'TrainerLicense was successfully created.') }
        format.xml  { render :xml => @trainer_license, :status => :created, :location => @trainer_license }
        format.json { render :json => @trainer_license, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trainer_license.errors, :status => :unprocessable_entity }
        format.json { render :json => @trainer_license.errors, :status => :unprocessable_entity}
      end
    end
  end

  # PUT /trainer_licenses/1
  # PUT /trainer_licenses/1.xml
  def update
    @trainer_license = TrainerLicense.find(params[:id])

    respond_to do |format|
      if @trainer_license.update_attributes(params[:trainer_license])
        format.html { redirect_to(@trainer_license, :notice => 'TrainerLicense was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trainer_license.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trainer_licenses/1
  # DELETE /trainer_licenses/1.xml
  def destroy
    @trainer_license = TrainerLicense.find(params[:id])
    @trainer_license.destroy

    respond_to do |format|
      format.html { redirect_to(trainer_licenses_url) }
      format.xml  { head :ok }
    end
  end
end
