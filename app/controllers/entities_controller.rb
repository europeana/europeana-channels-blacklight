# frozen_string_literal: true

class EntitiesController < ApplicationController
  include CacheHelper
  include Europeana::EntitiesAPIConsumer

  attr_reader :body_cache_key

  before_action :enforce_slug, only: :show

  def suggest
    api_params = entities_api_suggest_params(params.slice(:text, :language))
    api_response = Europeana::API.entity.suggest(api_params)
    render json: api_response
  end

  def show
    @body_cache_key = body_cache_key if entity_caching_enabled?
    unless body_cached? && entity_caching_enabled?
      @entity = EDM::Entity.build_from_params(entity_params)
      @search_keys_search_results = search_keys_search_results
    end
    respond_to do |format|
      format.html
      format.json { render json: @entity }
    end
  end

  private

  def enforce_slug
    redirect_to url_for(slug: slug, format: params[:format]) unless params[:slug] == slug
  end

  def entity
    @entity ||= begin
      api_params = entities_api_fetch_params(api_type, api_namespace, params[:id])
      Europeana::API.entity.fetch(api_params)
    end
  end

  def entity_caching_enabled?
    @entity_caching_enabled ||= Rails.application.config.x.enable.entity_page_caching && !Rails.application.config.x.disable.view_caching
  end

  def entity_params
    params.permit(:locale, :type, :id).merge(api_response: entity)
  end

  def search_keys_search_results
    @entity.search_keys.each_with_object({}) do |search_key, results|
      entity_search_params = { q: @entity.search_query(search_key) }
      (response, _documents) = search_results(entity_search_params)
      results[search_key] = response
    end
  end

  def slug
    @slug ||= Rails.cache.fetch(slug_cache_key) { entity_url_slug(entity) }
  end

  def slug_cache_key
    "entities/#{api_path}/slug"
  end

  def api_path
    @api_path ||= "#{api_type}/#{api_namespace}/#{params[:id]}"
  end

  def body_cache_key
    ['entities', params[:type], params[:id]].join('/')
  end

  def api_type
    @api_type ||= entities_api_type(params[:type])
  end

  def api_namespace
    'base'
  end
end
