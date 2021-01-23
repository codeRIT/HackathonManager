class Event < ApplicationRecord
  validates_presence_of :title, :start

  validate :finish_before_start

  def finish_before_start
    unless finish == nil && finish > start
      errors.add(:finish, 'time must be after start time')
    end
  end
end
