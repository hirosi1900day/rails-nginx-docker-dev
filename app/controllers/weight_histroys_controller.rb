class WeightHistroysController < ApplicationController
  before_action :set_weight_histroy, only: %i[ show edit update destroy ]

  # GET /weight_histroys or /weight_histroys.json
  def index
    @weight_histroys = WeightHistroy.all
  end

  # GET /weight_histroys/1 or /weight_histroys/1.json
  def show
  end

  # GET /weight_histroys/new
  def new
    @weight_histroy = WeightHistroy.new
  end

  # GET /weight_histroys/1/edit
  def edit
  end

  # POST /weight_histroys or /weight_histroys.json
  def create
    @weight_histroy = WeightHistroy.new(weight_histroy_params)

    respond_to do |format|
      if @weight_histroy.save
        format.html { redirect_to weight_histroy_url(@weight_histroy), notice: "Weight histroy was successfully created." }
        format.json { render :show, status: :created, location: @weight_histroy }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @weight_histroy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /weight_histroys/1 or /weight_histroys/1.json
  def update
    respond_to do |format|
      if @weight_histroy.update(weight_histroy_params)
        format.html { redirect_to weight_histroy_url(@weight_histroy), notice: "Weight histroy was successfully updated." }
        format.json { render :show, status: :ok, location: @weight_histroy }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @weight_histroy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weight_histroys/1 or /weight_histroys/1.json
  def destroy
    @weight_histroy.destroy

    respond_to do |format|
      format.html { redirect_to weight_histroys_url, notice: "Weight histroy was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_weight_histroy
      @weight_histroy = WeightHistroy.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def weight_histroy_params
      params.require(:weight_histroy).permit(:user_id, :weight, :memo)
    end
end
