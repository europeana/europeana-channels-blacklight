module Facet
  class HierarchicalPresenter < FacetPresenter
    def display(options = {})
      super.merge(hierarchical: true)
    end

    def facet_item(item)
      child_facets = item_children(item)

      {
        has_subfilters: child_facets.present?,
        filters: child_facets.map do |child|
          FacetPresenter.build(child, @controller).display
        end
      }.merge(super)
    end

    def item_children(item)
      facets_from_request(facet_field_names).select do |child|
        parent = @blacklight_config.facet_fields[child.name].parent
        if parent.is_a?(Array)
          (parent.first == @facet.name) && (parent.last == item.value)
        elsif !parent.nil?
          parent == @facet.name
        end
      end
    end

    ##
    # Removes all child facets from params
    def remove_facet_params(field, item, source_params = params)
      super.tap do |p|
        if p.key?(:f)
          item_children(item).each do |child|
            p[:f].delete(child.name)
          end
          p.delete(:f) if p[:f].empty?
        end
      end
    end
  end
end
