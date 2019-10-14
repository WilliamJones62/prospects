class User2s::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication, only: [:new, :create]
# Only skip if admin. How do I say that?
  def new
    if current_user2.email == "admin"
      @user = User2.new
    end
  end

  def create
    if current_user2.email == "admin"
      @user = User2.new(user_params)
       if @user.save
         redirect_to root_path
       else
         render :new
       end
     end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :manager_id)
  end
end
