# frozen_string_literal: true

class Feed < ActiveRecord::Base
  include HasExternalUrls

  has_and_belongs_to_many :pages

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true

  after_save :queue_retrieval

  acts_as_url :name, url_attribute: :slug, only_when_blank: true, allow_duplicates: false

  def html_url
    if tumblr?
      url.sub('/rss', '')
    elsif europeana_blog?
      url.sub('/feed', '')
    else
      url
    end
  end

  def to_param
    slug
  end

  def requeue
    queue_retrieval
  end

  def cache_key
    "feed/#{url}"
  end

  private

  def queue_retrieval
    Cache::FeedJob.perform_later(url)
  end
end
