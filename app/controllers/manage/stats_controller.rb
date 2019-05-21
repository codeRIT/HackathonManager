class Manage::StatsController < Manage::ApplicationController
  def index
  end

  def dietary_special_needs
    data = Rails.cache.fetch(cache_key_for_questionnaires("dietary_special_needs")) do
      select_attributes = [
        :first_name,
        :last_name,
        :phone,
        :checked_in_at,
        :dietary_restrictions,
        :special_needs,
        :user_id
      ]
      json_attributes = [
        :first_name,
        :last_name,
        :email,
        :phone,
        :checked_in_at,
        :dietary_restrictions,
        :special_needs
      ]
      data = Questionnaire.where("dietary_restrictions != '' AND acc_status = 'rsvp_confirmed' OR special_needs != '' AND acc_status = 'rsvp_confirmed'").select(select_attributes)
      to_json_array(data, json_attributes)
    end
    render json: { data: data }
  end

  def sponsor_info
    data = Rails.cache.fetch(cache_key_for_questionnaires("sponsor_info")) do
      select_attributes = [
        :id,
        :first_name,
        :last_name,
        :vcs_url,
        :portfolio_url,
        :user_id,
        :school_id
      ]
      json_attributes = [
        :first_name,
        :last_name,
        :email,
        :school_name,
        :vcs_url,
        :portfolio_url
      ]
      data = Questionnaire.where("can_share_info = '1' AND checked_in_at != 0").joins(:resume_attachment).select(select_attributes)
      json = to_json_array(data, json_attributes)
      json.map.with_index { |item, index| item.insert(6, data[index].resume.attached? ? url_for(data[index].resume) : '') }
    end
    render json: { data: data }
  end

  def alt_travel
    data = Rails.cache.fetch(cache_key_for_questionnaires("alt_travel")) do
      select_attributes = [
        :id,
        :first_name,
        :last_name,
        :travel_location,
        :acc_status,
        :user_id,
        :school_id
      ]
      json_attributes = [
        :id,
        :first_name,
        :last_name,
        :email,
        :travel_location,
        :acc_status
      ]
      data = Questionnaire.where("travel_not_from_school = '1'").select(select_attributes)
      json = to_json_array(data, json_attributes)
      json.each do |e|
        e[0] = view_context.link_to("View &raquo;".html_safe, manage_questionnaire_path(e[0]))
      end
    end
    render json: { data: data }
  end

  def mlh_info_applied
    data = Rails.cache.fetch(cache_key_for_questionnaires("mlh_info_applied")) do
      select_attributes = [
        :first_name,
        :last_name,
        :user_id,
        :school_id
      ]
      json_attributes = [
        :first_name,
        :last_name,
        :email,
        :school_name
      ]
      data = Questionnaire.joins(:school).select(select_attributes)
      to_json_array(data, json_attributes)
    end
    render json: { data: data }
  end

  def mlh_info_checked_in
    data = Rails.cache.fetch(cache_key_for_questionnaires("mlh_info_checked_in")) do
      select_attributes = [
        :first_name,
        :last_name,
        :user_id,
        :school_id
      ]
      json_attributes = [
        :first_name,
        :last_name,
        :email,
        :school_name
      ]
      data = Questionnaire.joins(:school).select(select_attributes).where('checked_in_at > 0')
      to_json_array(data, json_attributes)
    end
    render json: { data: data }
  end


  private

  def to_json_array(data, attributes)
    data.map { |e| attributes.map { |a| e.send(a) } }
  end

  def cache_key_for_questionnaires(id)
    count          = Questionnaire.count
    max_updated_at = Questionnaire.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "stats/all-#{count}-#{max_updated_at}-#{id}"
  end
end
