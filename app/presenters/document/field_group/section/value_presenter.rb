# frozen_string_literal: true

module Document
  module FieldGroup
    module Section
      ##
      # Presenter for one value of a metadata field
      #
      # TODO: should this be sub-classed? e.g. for single string values, language
      #   maps, entity-linked values
      class ValuePresenter < ApplicationPresenter
        include BlacklightDocumentPresenter
        include EntitiesHelper
        include UrlHelper

        attr_reader :document, :controller, :section, :content, :field, :entity
        delegate :blank?, :nil?, :present?, :empty?, to: :text

        # @param document [Europeana::Blacklight::Document]
        # @param controller [ActionController::Base]
        # @param section [Document::FieldGroup::SectionPresenter]
        # @param field [String,Symbol]
        # @param content [String]
        # @param entity [Europeana::Blacklight::Document]
        def initialize(document, controller, section, field, content, entity = nil)
          @document = document
          @controller = controller
          @section = section
          @field = field
          @content = content
          @entity = entity
        end

        def display
          {
            text: text,
            url: url,
            ga_data: section.ga_data,
            extra_info: extra_info,
            raw: section.html_line_breaks?
          }
        end

        def extra_info
          return nil unless for_entity? && section.entity_extra.present?
          return nil unless entity.present?
          nested_hash(section.entity_extra, entity)
        end

        def for_entity?
          entity.present?
        end

        def url
          if linkable_for_entity?
            url = entity_url
            return url unless url.nil?
          end

          return search_path if section.search_field.present?

          linkable_value? ? content : nil
        end

        def linkable_value?
          return false unless content.is_a?(String)
          content.start_with?('http://', 'https://')
        end

        def linkable_for_entity?
          for_entity? &&
            %w(agents concepts).include?(section.entity_name) # while only agent & concept entity pages are implemented
        end

        def entity_url
          return nil unless entity.present?

          begin
            entity_uri = URI.parse(entity.fetch('about'))
            return nil unless entity_uri.host == 'data.europeana.eu'
          rescue URI::Error
            return nil
          end

          type, namespace, id = entity_uri.path.split('/')[1..-1]
          return nil unless namespace == 'base'

          controller.entity_path(type: entities_human_type(type), id: id, slug: entity_url_slug(entity), format: 'html')
        end

        def search_path
          return nil if to_search.nil?

          controller.search_path(q: "#{section.search_field}:#{to_search}")
        end

        def to_search
          return nil unless content.is_a?(String)

          @search ||= begin
            if section.quoted?
              enquote_and_escape(content)
            else
              search = content.gsub(/[()\[\]<>]/, '')
              parenthesise_and_escape(search)
            end
          end
        end

        ##
        # Creates a nested hash of field values for Mustache template
        def nested_hash(mappings, subject)
          {}.tap do |hash|
            mappings.each do |mapping|
              val = subject.fetch(mapping[:field], nil)
              val = render_field_value(val)
              next unless val.present?

              keys = (mapping[:map_to] || mapping[:field]).split('.')
              last = keys.pop

              context = hash
              keys.each do |k|
                context[k] ||= {}
                context = context[k]
              end
              context[last] = format_date(val, mapping[:format_date])
            end
          end
        end

        def format_date(text, format)
          return text if format.nil? || (text !~ /^.+-/)
          Time.parse(text).strftime(format)
        rescue ArgumentError
          text
        end

        def text
          text = content.dup.to_s
          text = section.translate_value(text)
          text = text.titleize if text.present? && section.capitalised?
          text = format_date(text, section.format_date) if section.format_date?
          text = htmlify_line_breaks(text) if section.html_line_breaks?
          text
        end

        def htmlify_line_breaks(text)
          CGI.escapeHTML(text).gsub(/(\r\n|\r|\n)/, '<br/>').html_safe
        end

        def excluded?
          section.exclude_vals? && section.exclude_vals.include?(text)
        end
      end
    end
  end
end
