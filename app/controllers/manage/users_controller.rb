class Manage::UsersController < Manage::ApplicationController
  before_action :require_director
  before_action :find_user, only: [:show, :edit, :update, :reset_password, :destroy]

  respond_to :html, :json

  def index
    @user_search = User.ransack(params[:user_search], search_key: :user_search)
    @user_pagy, @users = pagy(@user_search.result(distinct: true), items: 10)
  end

  def staff_datatable
    render json: StaffDatatable.new(params, view_context: view_context)
  end

  def reset_password
    new_password = Devise.friendly_token(50)
    @user.reset_password(new_password, new_password)
    @user.send_reset_password_instructions
    flash[:notice] = t(:reset_password_success, scope: 'pages.manage.users.edit', full_name: @user.full_name)
    respond_with(:manage, @user, location: manage_users_path)
  end

  def show
  end

  def edit
  end

  def update
    @user.update(user_params)
    respond_with(:manage, @user, location: manage_users_path)
  end

  def destroy
    if @user.questionnaire.present?
      @user.questionnaire.destroy
    end
    @user.destroy
    respond_with(:manage, @user, location: manage_users_path)
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :role, :is_active, :receive_weekly_report
    )
  end

  def find_user
    @user = ::User.find(params[:id])
  end
end
