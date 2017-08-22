# frozen_string_literal: true
##
# View methods for pages with navigation
module NavigableView
  GLOBAL_PRIMARY_NAV_ITEMS_CACHE_KEY = 'global/navigation/primary_nav_items'

  extend ActiveSupport::Concern

  # URLs of feeds used to populate the global nav
  def self.feeds_included_in_nav_urls
    @feeds_included_in_nav_urls ||= begin
      all_blog_feed = Feed.find_by_slug('all-blog')
      all_blog_url = all_blog_feed.present? ? all_blog_feed.url : nil
      (Cache::FeedJob::URLS[:exhibitions].values + [all_blog_url]).compact
    end
  end

  def navigation
    mustache[:navigation] ||= begin
      {
        global: {
          options: {
            search_active: false,
            settings_active: true
          },
          logo: {
            url: home_path,
            text: 'Europeana ' + t('global.search-collections')
          },
          primary_nav: {
            menu_id: 'main-menu',
            items: cached_navigation_global_primary_nav_items
          }
        },
        home_url: home_url,
        footer: {
          linklist1: {
            title: t('global.more-info'),
            items: navigation_footer_linklist1_items
          },
          linklist2: {
            title: t('global.help'),
            items: navigation_footer_linklist2_items
          },
          social: {
            facebook: true,
            pinterest: true,
            twitter: true,
            googleplus: true
          }
        }
      }
    end
  end

  def utility_nav
    mustache[:utility_nav] ||= begin
      {
        menu_id: 'settings-menu',
        style_modifier: 'caret-right',
        tabindex: 6,
        items: [
          {
            url: '#',
            text: t('site.settings.language.label'),
            icon_class: 'svg-icon-language',
            submenu: {
              items: utility_nav_items_submenu_items
            }
          }
        ]
      }
    end
  end

  def styleguide_root
    styleguide_url
  end

  protected

  def exhibitions_feed_key
    @exhibitions_feed_key ||= Cache::FeedJob::URLS[:exhibitions].key?(I18n.locale) ? I18n.locale : :en
  end

  def submenu_has_current_page?(submenu)
    submenu.any? do |item|
      if item[:submenu]
        submenu_has_current_page?(item[:submenu][:items])
      else
        item[:is_current]
      end
    end
  end

  def navigation_global_primary_nav_items
    [
      {
        text: t('global.navigation.collections'),
        submenu: {
          items: navigation_global_primary_nav_collections_submenu_items
        }
      },
      {
        text: t('global.navigation.browse'),
        submenu: {
          items: navigation_global_primary_nav_explore_submenu_items
        }
      },
      {
        url: exhibitions_foyer_path(exhibitions_feed_key),
        text: t('global.navigation.exhibitions'),
        submenu: {
          items: navigation_global_primary_nav_exhibitions_submenu_items
        }
      },
      {
        url: 'http://blog.europeana.eu/',
        text: t('global.navigation.blog'),
        submenu: {
          items: navigation_global_primary_nav_blog_submenu_items
        }
      }
    ]
  end

  def cached_navigation_global_primary_nav_items
    nav_items = if config.x.disable.view_caching
                  navigation_global_primary_nav_items
                else
                  nav_cache_key = cache_key(GLOBAL_PRIMARY_NAV_ITEMS_CACHE_KEY)
                  Rails.cache.fetch(nav_cache_key) { navigation_global_primary_nav_items }
                end

    nav_items.each do |section|
      mark_current_page(section)
    end
  end

  def mark_current_page(section)
    section[:submenu][:items].each do |item|
      if item[:submenu]
        mark_current_page(item)
      else
        item[:is_current] = current_page?(item[:url])
      end
    end
    section[:is_current] = submenu_has_current_page?(section[:submenu][:items])
  end

  def navigation_global_primary_nav_collections_submenu_items
    displayable_collections.sort_by { |c| c.title.to_s }.map do |collection|
      link_item(collection.title, collection_path(collection))
    end
  end

  def navigation_global_primary_nav_explore_submenu_items
    mustache[:navigation_global_primary_nav_explore_submenu_items] ||= begin
      [
        link_item(t('global.navigation.browse_newcontent'), explore_newcontent_path(format: 'html')),
        link_item(t('global.navigation.browse_colours'), explore_colours_path(format: 'html')),
        link_item(t('global.navigation.browse_sources'), explore_sources_path(format: 'html')),
        link_item(t('global.navigation.concepts'), explore_topics_path(format: 'html')),
        link_item(t('global.navigation.agents'), explore_people_path(format: 'html')),
        link_item(t('global.navigation.periods'), explore_periods_path(format: 'html')),
        navigation_global_primary_nav_galleries
      ]
    end
  end

  def navigation_global_primary_nav_exhibitions_submenu_items
    mustache[:navigation_global_primary_nav_exhibitions_submenu_items] ||= begin
      feed_items = feed_entry_nav_items(Cache::FeedJob::URLS[:exhibitions][exhibitions_feed_key], 6)
      feed_items << link_item(t('global.navigation.all_exhibitions'), exhibitions_foyer_path(exhibitions_feed_key),
                              is_morelink: true)
    end
  end

  def navigation_global_primary_nav_blog_submenu_items
    mustache[:navigation_global_primary_nav_blog_submenu_items] ||= begin
      feed = Feed.find_by_slug('all-blog')
      return [] unless feed
      feed_items = feed_entry_nav_items(feed.url, 6)
      feed_items << link_item(t('global.navigation.all_blog_posts'), feed.html_url,
                              is_morelink: true)
    end
  end

  def navigation_global_primary_nav_galleries
    mustache[:navigation_global_primary_nav_galleries] ||= begin
      {
        text: t('global.navigation.galleries'),
        submenu: {
          items: navigation_global_primary_nav_galleries_submenu_items
        }
      }
    end
  end

  def navigation_global_primary_nav_galleries_submenu_items
    mustache[:navigation_global_primary_nav_galleries_submenu_items] ||= begin
      Gallery.published.order(published_at: :desc).limit(6).map do |gallery|
        link_item(gallery.title, gallery_path(gallery))
      end << link_item(t('global.navigation.all_galleries'), galleries_path, is_morelink: true)
    end
  end

  def utility_nav_items_submenu_items
    I18n.available_locales.map do |locale|
      label = t(locale, scope: 'global.languages', locale: locale)
      link_item(label, current_url_for_locale(locale),
                is_current: (locale.to_s == I18n.locale.to_s))
    end
  end

  def navigation_footer_linklist1_items
    [
      link_item(t('site.footer.menu.about'), static_page_path('about', format: 'html')),
      link_item(t('site.footer.menu.roadmap'), static_page_path('roadmap', format: 'html')),
      link_item(t('site.footer.menu.data-providers'), explore_sources_path(format: 'html')),
      link_item(t('site.footer.menu.become-a-provider'), 'http://pro.europeana.eu/share-your-data/'),
      link_item(t('site.footer.menu.contact-us'), static_page_path('contact', format: 'html')),
    ]
  end

  def navigation_footer_linklist2_items
    [
      link_item(t('site.footer.menu.search-tips'), static_page_path('help', format: 'html')),
      link_item(t('global.terms-and-policies'), static_page_path('rights', format: 'html'))
    ]
  end

  def link_item(text, url, options = {})
    { text: text, url: url, submenu: false }.merge(options)
  end

  def feed_entry_nav_items(url, max)
    feed_entries(url)[0..(max - 1)].map do |item|
      {
        url: CGI.unescapeHTML(item.url),
        text: CGI.unescapeHTML(item.title),
        submenu: false
      }
    end
  end
end
