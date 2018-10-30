class ProspectCallsController < ApplicationController
  before_action :set_prospect
  before_action :set_prospect_call, except: [:new, :create]

  def new
    @prospect_call = ProspectCall.new
  end

  def edit
  end

  def create
    @prospect_call = Prospect_calls.new(prospect_call_params)
    @prospect_call.save
    render action: 'show', status: :created, location:@prospect
  end

  def update
    @prospect_call.update(prospect_call_params)
  end

  def destroy
    @prospect_call.destroy
    redirect_to @prospect
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prospect
      @prospect = Prospect.find(params[:prospect_id])
    end
    def set_prospect_call
      @prospect_call = ProspectCall.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def prospect_call_params
      params.require(:prospect_call).permit(:prospect_id, :who, :outcome, :call_date)
    end
end
