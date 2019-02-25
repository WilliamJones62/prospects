class ProspectsController < ApplicationController
  before_action :set_prospect, only: [:show, :edit, :update, :destroy]
  before_action :set_first_and_last, only: [:show, :edit]
  before_action :set_user_and_manager, only: [:new, :edit]
  before_action :build_rep_list, only: [:summary]
  before_action :build_inactive_rep_list, only: [:inactive]

  # GET /prospects
  def index
    @user = current_user.email.upcase
    if @user == 'ADMIN'
      prospects = Prospect.where(status: false).to_a
    else
      prospects = Prospect.where(rep: @user).where(status: false).to_a
    end
    @name = []
    tempname = []
    prospects.each do |p|
      if !p.name.blank?
        tempname.push(p.name)
      end
    end
    @name = tempname.sort
  end

  # GET /prospects/1
  def show
    # need to read last 4 orders for the customer
    deleted_prospects = []
    @orders = []
    if @prospect.customer_id && @prospect.customer_id != ''
      # there is something in the customer field so see if there are any E21 records
      sales = DartSalesPricingCurrent.where(cust_code: @prospect.customer_id).take(4)
      # if sales && sales.length == 4
        # this customer is no longer a prospect so set it to inactive
        # inactive_prospects.push(prospect)
        # prospect.inactive = true
        # prospect.save
      # else
      if sales
        len = sales.length
        i = 0
        while i < len do
          @orders[i] = sales[i].order_date
          i += 1
        end
        # check the billto table to get the payment terms
      end
    end
    # inactive_prospects.each do |d|
      # remove deleted prospects from index list
      # b = @prospects.delete(d)
    # end
  end

  # GET /prospects/new
  def new
    @new = true
    @first = ' '
    @last = ' '
    @prospect = Prospect.new
    @prospect.prospect_calls.build
  end

  # GET /prospects/1/edit
  def edit
    @new = false
    $rep = @prospect.rep
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
    pp = prospect_params
    if pp[:rep] != $rep
      # rep has changed so store the previous rep
      pp[:prev_rep] = $rep
      pp[:rep_date] = Date.today
    end
    respond_to do |format|
      if @prospect.update(pp)
        format.html { redirect_to @prospect, notice: 'Prospect was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def list
    if !$prospect_reps
      # first time in
      @rep = []
      rep = []
      temprep = []
      reps = User.all
      reps.each do |r|
        if r.manager_id != 'MAINT' && r.email != 'admin'
          temprep.push(r.email.upcase)
        end
      end

      rep = temprep.sort
      $prospect_rep = rep[0]
      i = 1
      @selected_rep = 0
      rep.each do |c|
        select_item = []
        select_item.push(c)
        select_item.push(i)
        @rep.push(select_item)
        if c == $prospect_rep
          @selected_rep = i
        end
        i += 1
      end
      $prospect_reps = @rep
      prospects = Prospect.where(rep: $prospect_rep).to_a
      @name = []
      tempname = []
      prospects.each do |p|
        if !p.name.blank?
          tempname.push(p.name)
        end
      end
      @name = tempname.sort
      $prospect_names = @name
    else
      @selected_rep = 0
      $prospect_reps.each do |p|
        if p[0] == $prospect_rep
          @selected_rep = p[1]
        end
      end
      @rep = $prospect_reps
      @name = $prospect_names
    end

  end

  def selected
    reps = $prospect_reps
    reps.each do |c|
      select_item = []
      select_item = c
      if params[:prospect_rep] == select_item[1].to_s
        $prospect_rep = select_item[0]
        break
      end
    end
    prospects = Prospect.where(rep: $prospect_rep).to_a
    @name = []
    tempname = []
    prospects.each do |p|
      if !p.name.blank?
        tempname.push(p.name)
      end
    end
    @name = tempname.sort
    $prospect_names = @name
    redirect_to action: "list"
  end

  def custcode
    prospect = Prospect.find_by name: params[:prospect_name]
    if prospect
      prospect.customer_id = params[:prospect_code]
      prospect.save
    end
    redirect_to action: "index"
  end

  def chosen
    prospect = Prospect.find_by name: params[:prospect_name]
    redirect_to prospect
  end

  def summary
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prospect
      @prospect = Prospect.find(params[:id])
      session[:prospect_id] = @prospect_id
    end

    def set_user_and_manager
      @method = ['CALL', 'VOICEMAIL', 'EMAIL', 'TEXT', 'IN PERSON', 'SOCIAL MEDIA']
      @outcome = ['ORDER', 'INFORMATION REQUESTED', 'CALL BACK', 'NO INTEREST']
      @user = current_user.email.upcase
      @manager = false
      if @user == 'ADMIN' || current_user.manager_id.upcase == @user
        @manager = true
      end
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

    def build_rep_list
    # Set up the prospect list for the signed in rep or all prospects for an admin
      @user = current_user.email.upcase
      user = User.find_by(email: current_user.email)
      if user.manager_id
        @mngr = user.manager_id.upcase
      else
        @mngr = ' '
      end
      if @user == 'ADMIN'
        # see all the prospects
        @prospects = Prospect.where(status: false).to_a
      else
        # a manager should see all the prospects of their reps
        reps = User.where(manager_id: @mngr)
        @prospects = []
        reps.each do |r|
          rep = r.email.upcase
          prospects = Prospect.where(rep: rep).where(status: false).to_a
          @prospects = @prospects + prospects
        end
      end
    end

    def build_inactive_rep_list
    # Set up the prospect list for the signed in rep or all prospects for an admin
      @user = current_user.email.upcase
      user = User.find_by(email: current_user.email)
      if user.manager_id
        @mngr = user.manager_id.upcase
      else
        @mngr = ' '
      end
      if @user == 'ADMIN'
        # see all the prospects
        @prospects = Prospect.where(status: true).to_a
      else
        # a manager should see all the prospects of their reps
        reps = User.where(manager_id: @mngr)
        @prospects = []
        reps.each do |r|
          rep = r.email.upcase
          prospects = Prospect.where(rep: rep).where(status: true).to_a
          @prospects = @prospects + prospects
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prospect_params
      params.require(:prospect).permit(
        :customer_id, :name, :calls, :first_call, :last_call, :credit_terms, :rep, :status,
        prospect_calls_attributes: [
          :id,
          :who,
          :outcome,
          :call_date,
          :method,
          :subject
        ]
      )
    end
end
