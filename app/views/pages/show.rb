module Pages
  class Show < ApplicationView
    include BrowseEntryDisplayingView

    def page_content_heading
      @page.title
    end

    def head_meta
      mustache[:head_meta] ||= begin
        [
          { meta_name: 'description', content: truncate(strip_tags(@page.body), length: 350, separator: ' ') }
        ] + super
      end
    end

    def content
      mustache[:content] ||= begin
        {
          title: @page.title,
          text: @page.settings[:full_width] != '1' ? @page.body : nil,
          text_full_width: @page.settings[:full_width] == '1' ? @page.body : nil,
          channel_entry: @page.browse_entries.published.blank? ? nil : {
            items: browse_entry_items(@page.browse_entries.published, @page)
          },
          banner: banner_content(@page.banner_id)
        }.reverse_merge(super)
      end
    end

    def navigation
      mustache[:navigation] ||= begin
        (hide_secondary_navigation? ? {} : {
          secondary: {
            items: secondary_navigation_items
          }
        }).reverse_merge(super)
      end
    end

    protected

    def show_secondary_navigation?
      page_has_non_home_parent? || @page.children.present?
    end

    def hide_secondary_navigation?
      !show_secondary_navigation?
    end

    def page_has_non_home_parent?
      @page.parent.present? && @page.parent.slug.present?
    end

    def secondary_navigation_items
      base = page_has_non_home_parent? ? @page.parent : @page
      [
        {
          url: static_page_path(base, format: 'html'),
          text: base.title,
          is_current: current_page?(static_page_path(base, format: 'html')),
          submenu: base.children.blank? ? nil : {
            items: base.children.map do |child|
              {
                url: static_page_path(child, format: 'html'),
                text: child.title,
                is_current: current_page?(static_page_path(child, format: 'html')),
                submenu: false
              }
            end
          }
        }
      ]
    end

    private

    def body_cache_key
      @page.cache_key
    end
  end
end
