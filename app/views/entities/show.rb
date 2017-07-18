# frozen_string_literal: true

require 'digest'
require 'uri'

module Entities
  class Show < ApplicationView
    include EntityDisplayingView
    include SearchableView

    def bodyclass
      'channel_entity'
    end

    def page_content_heading
      get_entity_title
    end

    def navigation
      {
        breadcrumbs: [
          {
            label: 'Link#2',
            url: 'javascript:alert("Follow breadcrumb link 1")'
          },
          {
            label: 'Link#2',
            url: 'javascript:alert("Follow breadcrumb link 2")'
          },
          {
            label: get_entity_title
          }
        ]
      }.merge(super)
    end

    def include_nav_searchbar
      true
    end

    # TODO
    # def head_meta
    #   mustache[:head_meta] ||= begin
    #     title = page_title
    #     head_meta = [
    #       { meta_name: 'description', content: head_meta_description },
    #       { meta_property: 'fb:appid', content: '185778248173748' },
    #       { meta_name: 'twitter:card', content: 'summary' },
    #       { meta_name: 'twitter:site', content: '@EuropeanaEU' },
    #       { meta_property: 'og:sitename', content: title },
    #       { meta_property: 'og:description', content: head_meta_description },
    #       { meta_property: 'og:url', content: collection_url(@collection.key) }
    #     ]
    #     head_meta << { meta_property: 'og:title', content: title } unless title.nil?
    #     head_meta << { meta_property: 'og:image', content: @landing_page.og_image } unless @landing_page.og_image.blank?
    #     head_meta + super
    #   end
    # end

    def content
      params = get_entity_params
      mustache[:content] ||= begin
        content = {
          tab_items: [
            {
              tab_title: t('site.entities.tab_items.items_by', name: get_entity_name),
              url: search_path(q: @items_by_query, format: 'json'),
              search_url: search_path(q: @items_by_query)
            },
            {
              tab_title: t('site.entities.tab_items.items_about', name: get_entity_name),
              # TODO
              url: entities_fetch_items_about_path(params[:type], params[:namespace], params[:identifier])
            }
          ],
          input_search: input_search,
          social_share: entity_social_share,
          entity_anagraphical: [
            {
              label: t('site.entities.anagraphic.birth'),
              value: get_entity_birth
            },
            {
              label: t('site.entities.anagraphic.death'),
              value: get_entity_death
            },
            {
              label: t('site.entities.anagraphic.occupation'),
              value: get_entity_occupation
            }
          ]
        }

        entity_thumbnail = get_entity_thumbnail
        entity_external_link = get_entity_external_link
        entity_description = get_entity_description
        entity_title = get_entity_name

        content[:entity_title] = entity_title if entity_title
        content[:entity_thumbnail] = entity_thumbnail if entity_thumbnail
        content[:entity_external_link] = entity_external_link if entity_external_link
        content[:entity_description] = entity_description if entity_description
        content
      end
    end
  end
end
