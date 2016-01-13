module Europeana
  module Collections
    extend ActiveSupport::Concern
    include CollectionsHelper

    ##
    # Adds collection filter params to the API query
    def search_builder
      super.with_overlay_params(current_collection.api_params_hash)
    end

    def has_search_parameters?
      super || params.key?(:q)
    end
  end
end
