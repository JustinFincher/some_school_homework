class BackstagePropsController < ApplicationController
  before_action :set_backstage_prop, only: [:show, :edit, :update, :destroy]

  # GET /backstage_props
  # GET /backstage_props.json
  def index
    respond_to do |format|
      format.html { redirect_to edit_backstage_prop_url(get_the_only_prop) , notice: '' }
      format.json { render :show, location: edit_backstage_prop_url(get_the_only_prop) }
    end
  end

  # GET /backstage_props/1
  # GET /backstage_props/1.json
  def show
    respond_to do |format|
      format.html { redirect_to edit_backstage_prop_url(get_the_only_prop) , notice: '' }
      format.json { render :show, location: edit_backstage_prop_url(get_the_only_prop) }
    end
  end

  # GET /backstage_props/new
  def new
    @backstage_prop = BackstageProp.new
  end

  # GET /backstage_props/1/edit
  def edit
    set_backstage_prop
  end

  # POST /backstage_props
  # POST /backstage_props.json
  def create
    respond_to do |format|
      if !already_has_prop_exist?

        @backstage_prop = BackstageProp.new(backstage_prop_params)


        if @backstage_prop.save
          format.html { redirect_to @backstage_prop, notice: 'Backstage prop was successfully created.' }
          format.json { render :show, status: :created, location: @backstage_prop }
        else
          format.html { render :new }
          format.json { render json: @backstage_prop.errors, status: :unprocessable_entity }
        end

      else
        format.html { redirect_to get_the_only_prop, notice: 'Already has a prop.' }
        format.json { render :show, location: get_the_only_prop }
      end
    end

  end

  # PATCH/PUT /backstage_props/1
  # PATCH/PUT /backstage_props/1.json
  def update
    respond_to do |format|
      if @backstage_prop.update(backstage_prop_params)
        format.html { redirect_to @backstage_prop, notice: 'Backstage prop was successfully updated.' }
        format.json { render :show, status: :ok, location: @backstage_prop }
      else
        format.html { render :edit }
        format.json { render json: @backstage_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_plane_type
    @para = backstage_prop_params
  end

  # DELETE /backstage_props/1
  # DELETE /backstage_props/1.json
  def destroy
    @backstage_prop.destroy
    respond_to do |format|
      format.html { redirect_to backstage_props_url, notice: 'Backstage prop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_backstage_prop
    @backstage_prop = BackstageProp.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def backstage_prop_params
    params.fetch(:backstage_prop, {})
  end

  def already_has_prop_exist?
    return BackstageProp.any?
  end

  def get_the_only_prop
    if !already_has_prop_exist?
      @backstage_prop = BackstageProp.new
      @backstage_prop.save
    end
    return BackstageProp.first
  end
end
