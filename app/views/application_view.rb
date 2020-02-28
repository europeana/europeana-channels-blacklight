# frozen_string_literal: true

##
# A custom class for this project's Mustache templates
#
# Each page-specific view class should sub-class this.
#
# Public methods added to this class will be available to all Mustache
# templates.
class ApplicationView < Europeana::Styleguide::View
  include AssettedView
  include BanneredView
  include CacheableView
  include Europeana::FeedbackButton::FeedbackableView
  include LocalisableView
  include NavigableView

  def page_title
    [page_content_heading, site_title].flatten.reject(&:blank?).join(' - ')
  end

  # Override in view subclasses for use in #page_title
  def page_content_heading
    ''
  end

  def new_site_url
    uri = URI.parse('https://www.europeana.eu' + @request_fullpath.to_s)
    params = Rack::Utils.parse_query(uri.query).merge(utm_source: 'old-website', utm_medium: 'button')
    uri.query = Rack::Utils.build_query(params)
    uri.to_s
  end

  def js_vars
    [
      { name: 'enableCSRFWithoutSSL', value: config.x.enable[:csrf_without_ssl] },
      { name: 'googleAnalyticsKey', value: config.x.google.analytics_key },
      { name: 'googleAnalyticsLinkedDomains', value: google_analytics_linked_domains_js_var_value, unquoted: true },
      { name: 'googleOptimizeContainerID', value: config.x.google.optimize_container_id },
      { name: 'googleTagManagerContainerID', value: config.x.google.tag_manager_container_id },
      { name: 'i18nLocale', value: I18n.locale },
      { name: 'i18nDefaultLocale', value: I18n.default_locale },
      { name: 'requirementsApplication', value: js_application_requirements, unquoted: true },
      { name: 'siteNotice', value: site_notice },
      { name: 'ugcEnabledCollections', value: ugc_enabled_collections_js_var_value, unquoted: true }
    ] + super
  end

  def head_meta
    super.tap do |head_meta|
      # Remove CSRF meta tags which intefere with caching
      head_meta.reject! { |meta| %w(csrf-param csrf-token).include?(meta[:meta_name]) }
      head_meta << { meta_property: 'og:site_name', content: site_title }

      if config.x.google.site_verification.present?
        head_meta << { meta_name: 'google-site-verification', content: config.x.google.site_verification }
      end
    end
  end

  def head_links
    links = [
      { rel: 'search', type: 'application/opensearchdescription+xml',
        href: config.x.europeana[:opensearch_host] + '/opensearch.xml',
        title: 'Europeana Search' },
      { rel: 'alternate', href: current_url_without_locale, hreflang: 'x-default' }
    ] + alternate_language_links

    { items: links }
  end

  def fb_campaigns_on
    false
  end

  def page_config
    {
      newsletter: true
    }
  end

  def newsletter
    {
      form: {
        action: 'https://europeana.us3.list-manage.com/subscribe/post?u=ad318b7566f97eccc895e014e&amp;id=1d4f51a117',
        language_op: true
      }
    }
  end

  def content
    mustache[:content] ||= begin
      {
        banner: banner_content
      }
    end
  end

  def cookie_disclaimer
    {
      more_link: controller.static_page_path('rights/privacy', format: 'html')
    }
  end

  def site_notice
    display_site_notice? ? t('site.notice.outage-expected') : false
  end

  protected

  def display_site_notice?
    return false unless site_notice_enabled?
    unless site_notice_begin.nil?
      return false unless Time.zone.now >= site_notice_begin
    end
    unless site_notice_end.nil?
      return false unless Time.zone.now < site_notice_end
    end
    true
  end

  def site_notice_enabled?
    %w(1 on true yes).include?(config.x.enable.site_notice)
  end

  def site_notice_begin
    return nil unless config.x.schedule.site_notice_begin.present?
    @site_notice_begin ||= Time.zone.parse(config.x.schedule.site_notice_begin)
  end

  def site_notice_end
    return nil unless config.x.schedule.site_notice_end.present?
    @site_notice_end ||= Time.zone.parse(config.x.schedule.site_notice_end)
  end

  def ugc_enabled_collections_js_var_value
    js_array(Collection.ugc_acceptor_keys)
  end

  def google_analytics_linked_domains_js_var_value
    js_array(config.x.google.analytics_linked_domains)
  end

  def js_array(array)
    '[' + array.map { |value| "'#{value}'" }.join(',') + ']'
  end

  def site_title
    t('site.name')
  end

  def alternate_language_links
    I18n.available_locales.map do |locale|
      { rel: 'alternate', hreflang: locale, href: current_url_for_locale(locale) }
    end
  end

  def devise_user
    current_user || User.new(guest: true)
  end

  def mustache
    @mustache ||= {}
  end

  def config
    Rails.application.config
  end
end
