# frozen_string_literal: true
module Events
  class Show < ApplicationView
    def event_title
      presenter.title
    end
    alias_method :page_content_heading, :event_title

    def head_meta
      mustache[:head_meta] ||= begin
        image = presenter.image(:url)
        image = image[:src] unless image.nil?
        description = truncate(strip_tags(CGI.unescapeHTML(presenter.body)), length: 200)
        title = presenter.title.delete('"')

        head_meta = [
          { meta_name: 'description', content: description },
          { meta_property: 'og:description', content: description },
          { meta_property: 'og:image', content: image },
          { meta_property: 'og:title', content: title },
          { meta_property: 'og:sitename', content: title },
          { meta_property: 'fb:appid', content: '185778248173748' },
          { meta_name: 'twitter:card', content: 'summary' },
          { meta_name: 'twitter:site', content: '@EuropeanaEU' }
        ]
        head_meta + super
      end
    end

    def content
      mustache[:content] ||= begin
        {
          body: presenter.body,
          has_authors: @event.has_authors?,
          authors: presenter.authors,
          has_tags: @event.has_taxonomy?(:tags),
          tags: presenter.tags,
          label: presenter.label,
          event_date: presenter.date_range(:start_event, :end_event),
          date: presenter.date,
          introduction: presenter.introduction,
          event_image: presenter.image(:url, :teaser_image),
          geolocation: presenter.geolocation,
          read_time: presenter.read_time,
          social: event_social,
          location: {
            institute_name: presenter.location_name,
            address: presenter.location_address,
            time: presenter.time_range(:start_event, :end_event)
          }
        }
      end
    end

    def event_social
      {
        social_title: t('global.actions.share'),
        facebook: {
          text: 'Facebook',
          url: 'https://www.facebook.com/EuropeanaFashion'
        },
        twitter: {
          text: 'Twitter',
          url: 'https://twitter.com/eu_sounds'
        },
        pinterest: {
          text: 'Pinterest',
          url: 'https://uk.pinterest.com/europeana/'
        },
        googleplus: {
          text: 'Google Plus',
          url: 'https://plus.google.com/+europeana/posts'
        }
      }
    end

    def navigation
      mustache[:navigation] ||= begin
        {
          back_url: events_path,
          back_label: t('site.events.list.page-title')
        }.reverse_merge(super)
      end
    end

    protected

    def presenter
      @presenter ||= ProResourcePresenter.new(self, @event)
    end
  end
end
