module FeedHelper
  def feed_entries(url)
    feed = cached_feed(url)
    feed.present? ? feed.entries : []
  end

  def cached_feed(url)
    @cached_feeds ||= {}
    @cached_feeds[url] ||= begin
      Rails.cache.fetch("feed/#{url}")
    end
  end

  def feed_entry_thumbnail_url(entry)
    FeedEntryImage.new(entry).thumbnail_url
  end
end
