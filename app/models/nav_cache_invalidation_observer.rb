# frozen_string_literal: true

class NavCacheInvalidationObserver < ActiveRecord::Observer
  include CacheHelper

  observe :collection, :gallery

  def after_save(_)
    Cache::Expiry::GlobalNavJob.perform_later
  end

  def after_destroy(_)
    Cache::Expiry::GlobalNavJob.perform_later
  end
end
