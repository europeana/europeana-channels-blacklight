# frozen_string_literal: true
module Collections
  class Ugc < ApplicationView
    include BrowsableView
    include SearchableView

    def js_vars
      [
        {
          name: 'pageName', value: 'e7a_1418'
        }
      ]
    end

    def page_title
      'Europeana - First World War'
    end

    def content
      {
        base_1418_url: config.x.europeana_1914_1918_url,
        portal_url: home_url
      }
    end
  end
end
