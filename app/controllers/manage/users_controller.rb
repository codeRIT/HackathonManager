class Manage::UsersController < Manage::ApplicationController
  before_action :require_director
  before_action :authenticate_user!
  before_action :find_user, only: [:show, :edit, :update, :reset_password, :destroy]

  respond_to :json

  def index
  end

  def user_datatable
    render json: UserDatatable.new(params, view_context: view_context)
  end

  def staff_datatable
    render json: StaffDatatable.new(params, view_context: view_context)
  end

  def reset_password
    new_password = Devise.friendly_token(50)
    @user.reset_password(new_password, new_password)
    @user.send_reset_password_instructions
    head :ok
  end

  def show
  end

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.questionnaire.present?
      @user.questionnaire.destroy
    end
    @user.destroy
    head :ok
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :role, :is_active, :receive_weekly_report
    )
  end

  def find_user
    @user = User.find(params[:id])
  end
end
