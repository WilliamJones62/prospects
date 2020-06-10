class ProspectsController < ApplicationController
  before_action :set_prospect, only: [:show, :edit, :update, :destroy]
  before_action :set_first_and_last, only: [:show, :edit]
  before_action :set_user_and_manager
  before_action :build_rep_list, only: [:index]
  before_action :build_inactive_rep_list, only: [:inactive]
  before_action :build_customer_list, only: [:customer]

  # GET /prospects
  def index
  end

  # GET /prospects/1
  def show
  end

  # GET /prospects/new
  def new
    @new = true
    @first = ' '
    @last = ' '
    @required_date = Time.current.strftime('%Y-%m-%d')
    if $house_account
      #  fill in as much prospect information as possible for a house account
      o = Orderfrom.find_by(bus_name: $name)
      @prospect = Prospect.new(customer_id: o.cust_code, zip: o.zip, ship_to: o.ship_to, source: "HOUSE ACCOUNT")
    else
      @prospect = Prospect.new
    end
    @prospect.prospect_calls.build call_date: @required_date
  end

  # GET /prospects/1/edit
  def edit
    @new = false
    $rep = @prospect.rep
    $name = @prospect.name
    @required_date = Time.current.strftime('%Y-%m-%d')
    @prospect.prospect_calls.build call_date: @required_date
    # calls = @prospect.prospect_calls.all
    # @prospect_calls = calls.sort_by { |call| [call.call_date] }
  end

  # POST /prospects
  def create
    pp = prospect_params
    if !pp[:customer_id].blank? && pp[:ship_to].blank?
      pp[:ship_to] = pp[:customer_id]
    end
    pp[:customer] = false
    @prospect = Prospect.new(pp)
    @prospect.active_date = Date.today
    @prospect.name.upcase!
    @prospect.customer = false
    if !@prospect.zip.blank?
      a = Geocode.where(["zip = ?", @prospect.zip])
      if a.length > 0
        z = a[a.length-1]
        @prospect.city = z.city_name
        @prospect.state = z.state_name
      end
    end
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
    pp[:name].upcase!
    if pp[:rep] != $rep
      # rep has changed so store the previous rep
      pp[:prev_rep] = $rep
      pp[:rep_date] = Date.today
    end
    if !pp[:status] && @prospect.status
      # prospect has changed from inactive to active so store todays date
      pp[:active_date] = Date.today
    end
    if !pp[:zip].blank?
      a = Geocode.where(["zip = ?", pp[:zip]])
      if a.length > 0
        z = a[a.length-1]
        pp[:city] = z.city_name
        pp[:state] = z.state_name
      end
    end
    if !pp[:customer_id].blank? && pp[:ship_to].blank?
      pp[:ship_to] = pp[:customer_id]
    end
    respond_to do |format|
      if @prospect.update(pp)

        format.html { redirect_to @prospect, notice: 'Prospect was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @prospect.destroy
    respond_to do |format|
      format.html { redirect_to prospects_inactive_path, notice: 'Prospect was successfully deleted.' }
    end
  end

  def inactive
  end

  def list
    if !$prospect_reps
      # first time in
      @rep = []
      rep = []
      temprep = []
      reps = User2.all
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
    $name = params[:prospect_name]
    $rep = params[:rep]
    prospect = Prospect.find_by name: params[:prospect_name].upcase
    if prospect
      redirect_to prospect
    else
      redirect_to action: "index", notice: 'Prospect was not found.'
    end
  end

  def find
    $house_account = false
    prospect = Prospect.find_by name: params[:name].upcase
    if prospect
      if prospect.status
        redirect_to prospects_search_path, notice: 'Prospect inactive, contact manager.'
      else
        redirect_to prospects_search_path, notice: 'Prospect already allocated.'
      end
    else
      o = Orderfrom.where(bus_name: params[:name].upcase)
      if o && o.length > 0
        orderfrom = o.first
        if !orderfrom.acct_manager.blank?
          if orderfrom.acct_manager[0,2] == 'HO' || orderfrom.acct_manager[0,2] == 'DA'
            if @manager
              $house_account = true
              $name = orderfrom.bus_name
              redirect_to new_prospect_path, notice: 'Prospect is a House Account.'
            else
              redirect_to prospects_search_path, notice: 'Prospect is a House Account, contact manager.'
            end
          else
            redirect_to prospects_search_path, notice: 'Prospect is already an account.'
          end
        else
          redirect_to prospects_search_path, notice: 'Prospect is already an account.'
        end
      else
        $name = params[:name].upcase
        redirect_to action: "new"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prospect
      @prospect = Prospect.find(params[:id])
      session[:prospect_id] = @prospect_id
    end

    def set_user_and_manager
      @method = ['CALL', 'EMAIL', 'IN PERSON', 'SOCIAL MEDIA', 'TEXT']
      @outcome = ['CONTACT NOT AVAILABLE', 'CALL BACK REQUESTED', 'CREDIT APP SENT', 'INFORMATION REQUESTED', 'LEFT MESSAGE', 'MEETING SCHEDULED', 'NO INTEREST', 'ORDER']
      @source = ['CHEF REFERRAL', 'COLD CALL', 'EVENT', 'HOUSE ACCOUNT', 'NEW OPENING', 'PHONE CALL', 'SOCIAL MEDIA', 'WEBSITE LEADS', 'LOADED']
      @user = current_user2.email.upcase
      @mngr = current_user2.manager_id.upcase
      if current_user2.manager_id.upcase == 'ISR'
        @user_isr = @user
        @user = 'ADMIN'
      end
      @manager = false
      if @user == 'ADMIN' || @mngr == @user
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
      if @user == 'ADMIN'
        @reps = User2.all
        # see all the prospects
        @prospects = Prospect.where(status: false).to_a
      elsif @mngr == @user
        # a manager should see all the prospects of their reps
        @reps = User2.where(manager_id: @mngr)
        @prospects = []
        @reps.each do |r|
          rep = r.email.upcase
          prospects = Prospect.where(rep: rep).where(status: false).to_a
          @prospects = @prospects + prospects
        end
      else
        # a rep should only see there own prospects
        @prospects = Prospect.where(rep: @user).where(status: false).to_a
      end
      @first_call = []
      @first_unformatted = []
      @last_call = []
      @prospects.each do |p|
        # need to find the first, second, third and last call date, if they exist, for each prospect by looking at the calls
        # collect all the call_date fields, then sort them
        if p.prospect_calls.length == 0
          # no call data so set everything to spaces
          @first_call.push(' ')
          @first_unformatted.push(' ')
          @last_call.push(' ')
        else
          tempcalls = []
          if p.prospect_calls.length == 1
            # only one call
            @first_call.push(p.prospect_calls.first.call_date.strftime("%Y %m %d"))
            @first_unformatted.push(p.prospect_calls.first.call_date)
            @last_call.push(p.prospect_calls.first.call_date.strftime("%Y %m %d"))
          else
            p.prospect_calls.each do |c|
              tempcalls.push(c.call_date)
            end
            tempcalls.sort!
            if p.prospect_calls.length == 2
              @first_call.push(tempcalls[0].strftime("%Y %m %d"))
              @first_unformatted.push(tempcalls[0])
              @last_call.push(tempcalls[1].strftime("%Y %m %d"))
            else
              @first_call.push(tempcalls[0].strftime("%Y %m %d"))
              @first_unformatted.push(tempcalls[0])
              @last_call.push(tempcalls.last.strftime("%Y %m %d"))
            end
          end
        end
      end
    end

    def build_inactive_rep_list
    # Set up the prospect list for the signed in rep or all prospects for an admin
      if @user == 'ADMIN'
        # see all the prospects
        @prospects = Prospect.where(status: true).where(customer: false).to_a
      else
        # a manager should see all the prospects of their reps
        reps = User2.where(manager_id: @mngr)
        @prospects = []
        reps.each do |r|
          rep = r.email.upcase
          prospects = Prospect.where(rep: rep).where(status: true).where(customer: false).to_a
          @prospects = @prospects + prospects
        end
      end
    end

    def build_customer_list
    # Set up the prospect list for the signed in rep or all prospects for an admin
      if @user == 'ADMIN'
        # see all the prospects
        @prospects = Prospect.where(customer: true).to_a
      else
        # a manager should see all the prospects of their reps
        reps = User2.where(manager_id: @mngr)
        @prospects = []
        reps.each do |r|
          rep = r.email.upcase
          prospects = Prospect.where(rep: rep).where(customer: true).to_a
          @prospects = @prospects + prospects
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prospect_params
      params.require(:prospect).permit(
        :customer_id, :name, :credit_terms, :rep, :status, :source, :zip, :active_date, :city, :state, :ship_to, :new_opening, :compass, :customer,
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
