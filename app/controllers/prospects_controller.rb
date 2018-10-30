class ProspectsController < ApplicationController
  before_action :set_prospect, only: [:show, :edit, :update, :destroy]
  before_action :set_first_and_last, only: [:show, :edit]
  before_action :set_dropdowns, only: [:new, :edit]
  before_action :build_rep_list, only: [:index]

  # GET /prospects
  def index
    @i = 0
  end

  # GET /prospects/1
  def show
  end

  # GET /prospects/new
  def new
    @user = current_user.email.upcase
    @first = ' '
    @last = ' '
    @prospect = Prospect.new
    @prospect.prospect_calls.build
  end

  # GET /prospects/1/edit
  def edit
    @user = current_user.email.upcase
    @prospect.prospect_calls.build
  end

  # POST /prospects
  def create
    @prospect = Prospect.new(prospect_params)
    respond_to do |format|
      if @prospect.save
        format.html { redirect_to @prospect, notice: 'Prospect was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /prospects/1
  def update
    respond_to do |format|
      if @prospect.update(prospect_params)
        format.html { redirect_to @prospect, notice: 'Prospect was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /prospects/1
  def destroy
    @prospect.destroy
    respond_to do |format|
      format.html { redirect_to prospects_url, notice: 'Prospect was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prospect
      @prospect = Prospect.find(params[:id])
      session[:prospect_id] = @prospect_id
    end

    def set_first_and_last
      calls = @prospect.prospect_calls.all
      now = Date.today
      @first = now
      @last = now - 10000
      calls.each do |c|
        if !c.call_date
          c.call_date = now
          c.save
        end
        if c.call_date < @first
          @first = c.call_date
        end
        if c.call_date > @last
          @last = c.call_date
        end
      end
    end

    def set_dropdowns
      @credit = ['COD', 'CC', 'CREDIT TERMS']
    end

    def build_rep_list
    # Set up the prospect list for the signed in rep or all prospects for an admin
      @user = current_user.email.upcase
      if @user == 'ADMIN'
        @prospects = Prospect.all
      else
        @prospects = Prospect.where(rep: @user).to_a
      end
      # need to read last 4 orders for the customer
      deleted_prospects = []
      j = 0
      @orders = []
      @prospects.each do |prospect|
        if prospect.customer_id && prospect.customer_id != ''
          # there is something in the customer field so see if there are any E21 records
          sales = DartSalesPricingCurrent.where(cust_code: prospect.customer_id).take(4)
          if sales && sales.length == 4
            # this customer is no longer a prospect so delete it
            deleted_prospects.push(prospect)
            prospect.destroy
          else
            len = sales.length
            i = 0
            while i < len do
              @orders[j] = sales[i].order_date
              i += 1
              j += 1
            end
            while i < 3 do
              @orders[j] = ''
              i += 1
              j += 1
            end
          end
        else
          i = 0
          while i < 3 do
            @orders[j] = ''
            i += 1
            j += 1
          end
        end
      end
      deleted_prospects.each do |d|
        # remove deleted prospects from index list
        b = @prospects.delete(d)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prospect_params
      params.require(:prospect).permit(
        :customer_id, :name, :calls, :first_call, :last_call, :credit_terms, :rep,
        prospect_calls_attributes: [
          :id,
          :who,
          :outcome,
          :call_date
        ]
      )
    end
end
