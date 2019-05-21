class BusListsController < ApplicationController
  before_action :logged_in
  before_action :check_user_has_questionnaire
  before_action :find_questionnaire
  before_action :find_bus_list
  before_action :require_bus_captain

  def logged_in
    authenticate_user!
  end

  # GET /bus_list
  def show
  end

  # PATCH /bus_list/boarded_bus
  def boarded_bus
    boarded_bus = params[:questionnaire][:boarded_bus].to_s
    questionnaire = Questionnaire.find_by_id(params[:questionnaire][:id])

    if !['true', 'false'].include?(boarded_bus) || questionnaire.blank?
      head :bad_request
      return
    end

    if questionnaire.bus_list.id != @bus_list.id
      head :bad_request
      return
    end

    if boarded_bus == 'true'
      questionnaire.update_attribute(:boarded_bus_at, Time.now)
    else
      questionnaire.update_attribute(:boarded_bus_at, nil)
    end
    head :ok
  end

  private

  def find_questionnaire
    @questionnaire = current_user.questionnaire
    redirect_to root_path unless @questionnaire
  end

  def find_bus_list
    @bus_list = @questionnaire.bus_list
    redirect_to root_path unless @bus_list
  end

  def check_user_has_questionnaire
    redirect_to root_path if current_user.questionnaire.nil?
  end

  def require_bus_captain
    redirect_to root_path unless @questionnaire.is_bus_captain?
  end
end
