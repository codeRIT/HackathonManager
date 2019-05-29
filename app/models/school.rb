class School < ApplicationRecord
  audited

  validates_presence_of :name

  validates_uniqueness_of :name

  strip_attributes

  has_many :questionnaires

  def full_name
    out = ""
    out << name
    if full_location.present?
      out << " in "
      out << full_location
    end
    out
  end

  def full_location
    out = ""
    out << city if city.present?
    out << ", " if city.present? && state.present?
    out << state if state.present?
    out
  end

  def fips_code
    Fips.where(city: city, state: state).first
  end
end
