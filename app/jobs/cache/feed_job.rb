module Cache
  class FeedJob < ApplicationJob
    URLS = {
      blog: {
        all: 'http://blog.europeana.eu/feed/',
        music: 'http://blog.europeana.eu/tag/music/feed/',
        art_history: 'http://blog.europeana.eu/tag/art-history/feed/'
      },
      exhibitions: %i(de en).each_with_object({}) do |locale, hash|
        hash[locale] = (ENV['EXHIBITIONS_HOST'] || 'http://www.europeana.eu') + "/portal/#{locale}/exhibitions/feed.xml"
      end
    }

    queue_as :high_priority

    def perform(url)
      @feed = begin
        benchmark("[Feedjira] #{url}", level: :info) do
          Feedjira::Feed.fetch_and_parse(url)
        end
      end
      Rails.cache.write("feed/#{url}", @feed)
    end
  end
end
