class UsersController < ApplicationController
  respond_to :json

  before_action :authenticate_user!, except: [:login, :register]
  before_action :find_user
  skip_before_action :authenticate_user, only: [:login, :register]

  def login
    user = User.find_by_email(params[:email])

    if user&.valid_password?(params[:password])
      @current_user = user
      render json: user.generate_jwt
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  def register
    user = ::User.new(user_params)
    if user.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def show
  end

  def update
    if current_user.update_attributes(user_params)
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
                                 :password_confirmation, :remember_me, :role, :is_active, :receive_weekly_report)
  end
end
