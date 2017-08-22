module EDM
  class Rights < Base
    class << self
      def registry
        @registry ||= begin
          registry_entries.flat_map do |reusability, entries|
            entries.map do |id, attrs|
              new({ id: id.to_sym, reusability: reusability }.merge(attrs || {}))
            end
          end
        end
      end

      def normalise(string)
        return nil unless string.is_a?(String)
        registry.detect { |rights| string.match(rights.pattern) }
      end

      def api_query_map
        @api_query_map ||= {}
      end

      def from_api_query(value)
        return nil if value.blank?
        api_query_map[value] ||= begin
          simple_value = value.to_s.tr('?*', '')
          registry.detect { |rights| simple_value.match(rights.pattern) }
        end
      end
    end

    def api_query
      pattern.gsub(/\(.*\)\?|.\?/, '*') + '*'
    end

    def i18n_key
      id.to_s.tr('_', '-')
    end

    def label
      label = I18n.t("advanced-#{i18n_key}", scope: 'global.facet.reusability')
      return label unless label.blank? && (I18n.locale != I18n.default_locale)
      I18n.t("advanced-#{i18n_key}", scope: 'global.facet.reusability', locale: I18n.default_locale)
    end
  end
end
