class RegionsController < ApplicationController
  before_action :set_ncmb
  before_action :set_region, only: %i[ show edit update destroy ]
  before_action :authenticate_admin!
  before_action -> { normal_limit(1)}
  layout 'autho', only: [:index]

  # GET /regions or /regions.json
  def index
    @regions = @object.all
  end

  # GET /regions/1 or /regions/1.json
  def show
    p_obj = NCMB::DataStore.new "Prefecture"
    @prefectures = p_obj.where("regionId", params['id'])
  end

  # GET /regions/new
  def new
    @region = Region.new
  end

  # GET /regions/1/edit
  def edit
  end

  # POST /regions or /regions.json
  def create
    @region = @object.new(region_params)
    @region.acl = nil

    respond_to do |format|
      if @region.save
        format.html { redirect_to region_path(@region.objectId), notice: "Region was successfully created." }
        format.json { render :show, status: :created, location: @region }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /regions/1 or /regions/1.json
  def update
    respond_to do |format|
      @region.objectId = params["id"]
      @region.name = params["name"]
      @region.acl = nil
      if @region.save
        format.html { redirect_to region_path(params["id"]), notice: "Region was successfully updated." }
        format.json { render :show, status: :ok, location: @region }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /regions/1 or /regions/1.json
  def destroy
    redirect_to regions_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_region
      @region = @object.where("objectId", params["id"]).first
    end

    def set_ncmb
      @object = NCMB::DataStore.new "Region"
    end

    # Only allow a list of trusted parameters through.
    def region_params
      params.require(:region).permit(:objectId, :name)
    end
end
