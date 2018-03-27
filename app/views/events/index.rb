# frozen_string_literal: true

module Events
  class Index < ApplicationView
    include PaginatedJsonApiResultSetView
    include ThemeFilterableView

    def head_links
      mustache[:head_links] ||= begin
        { items: [{ rel: 'alternate', type: 'application/rss+xml', href: events_url(format: 'rss') }] + super[:items] }
      end
    end

    def theme_filters
      pro_json_api_theme_filters
    end

    def selected_theme
      pro_json_api_selected_theme
    end

    def page_content_heading
      t('site.events.list.page-title')
    end

    def navigation
      mustache[:navigation] ||= begin
        {
          pagination: pagination_navigation
        }.reverse_merge(super)
      end
    end

    def hero
      mustache[:hero] ||= begin
        {
          hero_image: @hero_image.present? && @hero_image.file.present? ? @hero_image.file.url : nil
        }
      end
    end

    def event_items
      @events.map { |event| event_item(event) }
    end

    def events_filter_options
      return nil unless config.x.enable.events_theme_filter
      theme_filter_options
    end

    # @todo this selected filter option logic should be abstracted into a concern
    #   or helper method to DRY things up. See also `ThemeFilterableView#theme_filter_options`
    def events_order_options
      selected_past_future_options = past_future_filters.map { |key, data| { label: data[:label], value: key } }.tap do |options|
        selected_option = options.delete(options.detect { |option| option[:value] == selected_past_future })
        options.unshift(selected_option.merge(selected: true)) unless selected_option.nil?
      end

      {
        filter_name: 'sort',
        options: selected_past_future_options
      }
    end

    protected

    def event_item(event)
      presenter = ProResourcePresenter.new(self, event)
      {
        title: presenter.title,
        object_url: event_path(slug: event.slug),
        description: presenter.teaser,
        date: presenter.date_range(:start_event, :end_event),
        location: presenter.location_name,
        img: presenter.image(:thumbnail, :teaser_image),
        label: presenter.label,
        tags: presenter.tags
      }
    end

    def paginated_set
      @events
    end
  end
end
