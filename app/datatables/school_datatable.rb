class SchoolDatatable < AjaxDatatablesRails::Base
  def_delegators :@view, :link_to, :manage_school_path, :bold

  def view_columns
    @view_columns ||= {
      id: { source: 'School.id', cond: :eq },
      name: { source: 'School.name' },
      city: { source: 'School.city' },
      state: { source: 'School.state' },
      questionnaire_count: { source: 'School.questionnaire_count', searchable: false }
    }
  end

  private

  def data
    records.map do |record|
      {
        id: record.id,
        name: link_to(bold(record.name), manage_school_path(record)),
        city: record.city,
        state: record.state,
        questionnaire_count: record.questionnaire_count
      }
    end
  end

  # rubocop:disable Naming/AccessorMethodName
  def get_raw_records
    School.all
  end
  # rubocop:enable Naming/AccessorMethodName
end
