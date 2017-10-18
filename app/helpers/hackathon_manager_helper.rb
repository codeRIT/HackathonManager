module HackathonManagerHelper
  def title(page_title)
    content_for(:title) { page_title + " - #{Rails.configuration.hackathon['name']}" }
    page_title
  end

  def btn_link_to(name, path, options = {})
    options[:class] ? options[:class] += " button" : options[:class] = "button"
    link_to(name, path, options)
  end

  def phone_link_to(phone_number)
    link_to(phone_number, "tel:#{phone_number}")
  end

  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       no_intra_emphasis: true,
                                       fenced_code_blocks: true,
                                       disable_indented_code_blocks: true,
                                       autolink: true,
                                       tables: true,
                                       underline: true,
                                       hard_wrap: true)
    markdown.render(text).html_safe
  end

  # https://github.com/rails/sprockets-rails/issues/298#issuecomment-168927471
  def asset_available?(logical_path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include? logical_path
    else
      Rails.application.assets_manifest.assets[logical_path].present?
    end
  end
end
