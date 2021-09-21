class User < ApplicationRecord
  audited only: [:first_name, :last_name, :email, :role, :is_active, :receive_weekly_report]

  strip_attributes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :questionnaire
  has_many :access_grants, class_name: "Doorkeeper::AccessGrant",
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks
  has_many :access_tokens, class_name: "Doorkeeper::AccessToken",
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks

  accepts_nested_attributes_for :questionnaire

  validates_uniqueness_of :email
  validates_presence_of :first_name, :last_name

  after_create :queue_reminder_email
  after_initialize :set_default_role, if: :new_record?

  enum role: { user: 0, volunteer: 1, organizer: 2, director: 3 }

  def generate_jwt
    JWT.encode({ id: id,
                 exp: 30.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end

  def set_default_role
    self.role ||= :user
  end

  def active_for_authentication?
    super && is_active
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def queue_reminder_email
    return if reminder_sent_at
    UserMailer.incomplete_reminder_email(id).deliver_later(wait: 1.day)
    update_attribute(:reminder_sent_at, Time.now)
  end

  def email=(value)
    super value.try(:downcase)
  end

  def safe_receive_weekly_report
    return false unless is_active
    receive_weekly_report
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def staff?
    director? || organizer? || volunteer?
  end

  def organizing_staff?
    director? || organizer?
  end

  def self.from_omniauth(auth)
    matching_provider = where(provider: auth.provider, uid: auth.uid)
    matching_email = where(email: auth.info.email)
    current_user = matching_provider.or(matching_email).first_or_create do |user|
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.provider = auth.provider
      user.password = Devise.friendly_token[0, 20]
    end
    # Autofill MyMLH provider if provider info is missing
    # (as we are executing this from OAuth)
    if current_user.provider.blank?
      current_user.provider = auth.provider
    end
    current_user
  end

  def self.non_organizer
    User.where.not(role: :director).where.not(role: :organizer)
  end

  def self.without_questionnaire
    non_organizer.left_outer_joins(:questionnaire).where(questionnaires: { id: nil })
  end

  def as_json(options = {})
    result = super
    result['questionnaire_id'] = Questionnaire.where(user_id: id).any? ? Questionnaire.where(user_id: id).first.id : nil
    result
  end
end
