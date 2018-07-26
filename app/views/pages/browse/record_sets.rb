# frozen_string_literal: true

module Pages
  module Browse
    class RecordSets < Pages::Show
      include SearchableView

      def js_var_page_name
        'portal/browse'
      end

      def bodyclass
        'channels-browse'
      end

      def include_nav_searchbar
        true
      end

      def content
        {
          anchor_title: page.sets.present?,
          browse_lists: page.sets&.map { |set| content_browse_list(set) },
          helpbar_tip: t('site.helpbar-tip.browse-page')
        }
      end

      private

      def content_browse_list_foot_link_text
        @content_browse_list_foot_link_text ||= begin
          page.link_text.present? ? page.link_text : t('site.pages.browse.record_sets.link_text')
        end
      end

      def content_browse_list(set)
        {
          head: {
            pref_label: set.pref_label
          },
          foot: {
            link: {
              text: format(content_browse_list_foot_link_text, set_pref_label: set.pref_label),
              url: content_browse_list_foot_link_url(set)
            }
          },
          items: set.europeana_ids&.map { |id| content_browse_list_item(id) }
        }
      end

      def content_browse_list_foot_link_url(set)
        search_url_with_query(set.full_query)
      end

      def content_browse_list_item(id)
        return {} if items[id].blank?

        presenter = Document::SearchResultPresenter.new(items[id], controller)
        link_text = presenter.title
        texts = [presenter.fv('year')].compact

        {
          img_url: presenter.thumbnail_url,
          url: document_path(id: id[1..-1], format: 'html'),
          has_text: link_text.present? || texts.present?,
          link_text: link_text,
          texts: texts
        }
      end
    end
  end
end
