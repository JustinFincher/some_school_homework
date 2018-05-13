class PlaneBlueprintsController < ApplicationController
  before_action :set_plane_blueprint, only: [:show, :edit, :update, :destroy]

  # GET /plane_blueprints
  # GET /plane_blueprints.json
  def index
    @plane_blueprints = PlaneBlueprint.all
  end

  # GET /plane_blueprints/1
  # GET /plane_blueprints/1.json
  def show
  end

  # GET /plane_blueprints/new
  def new
    @plane_blueprint = PlaneBlueprint.new
  end

  # GET /plane_blueprints/1/edit
  def edit
  end

  # POST /plane_blueprints
  # POST /plane_blueprints.json
  def create
    @plane_blueprint = PlaneBlueprint.new(plane_blueprint_params)

    respond_to do |format|
      if @plane_blueprint.save
        format.html { redirect_to @plane_blueprint, notice: 'Plane blueprint was successfully created.' }
        format.json { render :show, status: :created, location: @plane_blueprint }
      else
        format.html { render :new }
        format.json { render json: @plane_blueprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plane_blueprints/1
  # PATCH/PUT /plane_blueprints/1.json
  def update
    respond_to do |format|
      if @plane_blueprint.update(plane_blueprint_params)
        format.html { redirect_to @plane_blueprint, notice: 'Plane blueprint was successfully updated.' }
        format.json { render :show, status: :ok, location: @plane_blueprint }
      else
        format.html { render :edit }
        format.json { render json: @plane_blueprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plane_blueprints/1
  # DELETE /plane_blueprints/1.json
  def destroy
    @plane_blueprint.destroy
    respond_to do |format|
      format.html { redirect_to plane_blueprints_url, notice: 'Plane blueprint was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plane_blueprint
      @plane_blueprint = PlaneBlueprint.find(params[:id])

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plane_blueprint_params
      params.require(:plane_blueprint).permit(:seat_map,:name)
    end
end
