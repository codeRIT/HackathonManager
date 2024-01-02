class BulkMessageDatatable < ApplicationDatatable
  def_delegators :@view, :link_to, :manage_message_path, :display_datetime, :bold, :h

  def view_columns
    @view_columns ||= {
      id: { source: "Message.id" },
      name: { source: "Message.name" },
      subject: { source: "Message.subject" },
      status: {},
      created_at: { source: "Message.created_at", searchable: false },
      updated_at: { source: "Message.updated_at", searchable: false },
      delivered_at: { source: "Message.delivered_at", searchable: false },
    }
  end

  private

  def data
    records.map do |record|
      {
        id: record.id,
        name: link_to(bold(record.name), manage_message_path(record)),
        subject: record.subject,
        status: record.status == "drafted" ? "<span style=\"color: red;\">#{h(record.status.titleize)}</span>".html_safe : record.status.titleize,
        created_at: display_datetime(record.created_at),
        updated_at: record.updated_at.present? ? display_datetime(record.updated_at) : "",
        delivered_at: record.delivered_at.present? ? display_datetime(record.delivered_at) : "",
      }
    end
  end

  def get_raw_records
    Message.where(type: "bulk")
  end
end
