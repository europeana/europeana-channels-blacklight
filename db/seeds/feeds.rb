# frozen_string_literal: true

unless Feed.find_by_slug('all-blog').present?
  Feed.create!(
    name: 'All Blog',
    url: 'http://blog.europeana.eu/feed/'
  )
end
unless Feed.find_by_slug('art-blog').present?
  Feed.create!(
    name: 'Art Blog',
    url: 'http://blog.europeana.eu/tag/art/feed/'
  )
end
unless Feed.find_by_slug('music-blog').present?
  Feed.create!(
    name: 'Music Blog',
    url: 'http://blog.europeana.eu/tag/music/feed/'
  )
end
unless Feed.find_by_slug('fashion-blog').present?
  Feed.create!(
    name: 'Fashion Blog',
    url: 'http://blog.europeana.eu/tag/fashion/feed/'
  )
end
unless Feed.find_by_slug('fashion-tumblr').present?
  Feed.create!(
    name: 'Fashion Tumblr',
    url: 'http://europeanafashion.tumblr.com/rss'
  )
end
unless Feed.find_by_slug('exhibitions-en').present?
  Feed.create!(
    name: 'Exhibitions (EN)',
    url: 'https://www.europeana.eu/portal/en/exhibitions/feed.xml'
  )
end
unless Feed.find_by_slug('exhibitions-de').present?
  Feed.create!(
    name: 'Exhibitions (DE)',
    url: 'https://www.europeana.eu/portal/de/exhibitions/feed.xml'
  )
end
