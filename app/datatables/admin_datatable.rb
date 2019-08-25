class AdminDatatable < ApplicationDatatable
  def_delegators :@view, :link_to, :manage_admin_path, :bold, :display_datetime

  def view_columns
    @view_columns ||= {
      id: { source: "User.id" },
      email: { source: "User.email" },
      role: { source: "User.role", searchable: false },
      active: { source: "User.is_active", searchable: false },
      receive_weekly_report: { source: "User.receive_weekly_report", searchable: false },
      created_at: { source: "User.created_at", searchable: false },
      current_sign_in_at: { source: "User.current_sign_in_at", searchable: false },
      last_sign_in_at: { source: "User.last_sign_in_at", searchable: false },
      current_sign_in_ip: { source: "User.current_sign_in_ip" },
      last_sign_in_ip: { source: "User.last_sign_in_ip" },
      sign_in_count: { source: "User.sign_in_count", searchable: false },
    }
  end

  private

  def data
    records.map do |record|
      {
        id: record.id,
        email: link_to(bold(record.email), manage_admin_path(record)),
        role: record.role.titleize,
        active: record.is_active ? '<span class="badge badge-secondary">Active</span>'.html_safe : '<span class="badge badge-danger">Inactive<span>'.html_safe,
        receive_weekly_report: yes_no_display(record.receive_weekly_report),
        created_at: display_datetime(record.created_at),
        current_sign_in_at: display_datetime(record.current_sign_in_at),
        last_sign_in_at: display_datetime(record.last_sign_in_at),
        current_sign_in_ip: record.current_sign_in_ip == "::1" ? "127.0.0.1" : record.current_sign_in_ip,
        last_sign_in_ip: record.last_sign_in_ip == "::1" ? "127.0.0.1" : record.last_sign_in_ip,
        sign_in_count: record.sign_in_count,
      }
    end
  end

  def get_raw_records
    User.where(role: [:admin, :admin_limited_access, :event_tracking])
  end
end
