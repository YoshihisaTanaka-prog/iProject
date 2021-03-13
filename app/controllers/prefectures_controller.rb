class PrefecturesController < ApplicationController
  before_action :set_ncmb
  before_action :set_prefecture, only: %i[ show edit update destroy ]
  before_action :authenticate_admin!
  before_action -> { normal_limit(1)}
  layout 'autho', only: [:index]

  # GET /prefectures or /prefectures.json
  def index
    redirect_to regions_path
  end

  # GET /prefectures/1 or /prefectures/1.json
  def show
  end

  # GET /prefectures/new
  def new
    @prefecture = Prefecture.new
  end

  # GET /prefectures/1/edit
  def edit
  end

  # POST /prefectures or /prefectures.json
  def create
    @prefecture = @object.new(prefecture_params)
    @prefecture.acl = nil

    respond_to do |format|
      if @prefecture.save
        format.html { redirect_to prefecture_path(@prefecture.objectId), notice: "Prefecture was successfully created." }
        format.json { render :show, status: :created, location: @prefecture }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prefecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prefectures/1 or /prefectures/1.json
  def update
    @prefecture.objectId = params["id"]
    @prefecture.regionId = params["r_id"]
    @prefecture.name = params["name"]
    @prefecture.acl = nil
    respond_to do |format|
      if @prefecture.save
        format.html { redirect_to prefecture_path(params['id']), notice: "Prefecture was successfully updated." }
        format.json { render :show, status: :ok, location: @prefecture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prefecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prefectures/1 or /prefectures/1.json
  def destroy
    redirect_to prefectures_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prefecture
      @prefecture = @object.where("objectId", params["id"]).first
    end

    def set_ncmb
      @object = NCMB::DataStore.new "Prefecture"
    end

    # Only allow a list of trusted parameters through.
    def prefecture_params
      params.require(:prefecture).permit(:regionId, :objectId, :name)
    end
end
