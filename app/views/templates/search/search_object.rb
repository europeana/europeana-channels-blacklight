module Templates
  module Search
    class SearchObject < Stache::Mustache::View
      def back_link
         link_back_to_catalog(label: 'return to search results')
      end

      def prev_link
        begin
          link_to_previous_document(@previous_document)
        rescue
          '(prev link error)'
        end
      end

      def next_link
        begin
          link_to_next_document(@next_document)
        rescue
          '(next link error)'
        end
      end

      def links
        res = {
          :download  => document.get('europeanaAggregation.edmPreview'),
          :original_context => document.get('aggregations.edmIsShownAt')
        }
      end

      def labels
        {
          :show_more_meta => "show more object data",
          :download => "download",
          :rights => "rights:",
          :description => "description:",
          :agent => get_agent_label,
          :mlt => "similar items"
        }
      end
            
      def data
        {
          :agent_pref_label => document.get('agents.prefLabel'),
          :agent_begin  => document.get('agents.begin'),
          :agent_end  => document.get('agents.end'),
          
          :concepts => get_doc_concepts,
          
          :dc_description => document.get('proxies.dcDescription'),
          :dc_type => document.get('proxies.dcType'),
          :dc_creator => document.get('proxies.dcCreator'),

          :dc_format => document.get('proxies.dcFormat'),
          :dc_identifier => document.get('proxies.dcIdentifier'),

          :dc_terms_created => document.get('proxies.dctermsCreated'),
           
          :dc_terms_created_web => document.get('aggregations.webResources.dctermsCreated'),

          :dc_terms_extent => document.get('proxies.dctermsExtent'),
          :dc_title => document.get('proxies.dcTitle'),

          :edm_country => document.get('europeanaAggregation.edmCountry'),
          :edm_dataset_name => document.get('edmDatasetName'),
          :edm_is_shown_at => document.get('aggregations.edmIsShownAt'),
          :edm_is_shown_by => document.get('aggregations.edmIsShownBy'),
          :edm_language => document.get('europeanaAggregation.edmLanguage'),
          :edm_preview => document.get('europeanaAggregation.edmPreview'),
          :edm_provider => document.get('aggregations.edmProvider'),
          :edm_rights =>  document.get('aggregations.edmRights'),

          :latitude => document.get('places.latitude'),
          :longitude => document.get('places.longitude'),

          :title => get_doc_title,
          :title_extra => get_doc_title_extra,
          :type => document.get('type'),

          :year => document.get('year')
        }
      end

      # All
      def doc
        document.as_json.to_s 
      end

      private
      
      def get_doc_title
        
        # force array return with empty default

        title = document.get('title', :default=>'')
        title = title.size == 0 ? document.get('proxies.dcTitle') : title[0]
        title
      end
      
      def get_doc_title_extra
        
        # force array return with empty default
        
        title = document.get('title', :default=>'')
        if title.size > 1
          title.shift
          title
        else
          nil
        end
      end

      def get_agent_label
        x = document.get('agents.rdaGr2ProfessionOrOccupation')
        x ||= 'creator'
        x        
      end
      
      
      def get_doc_concepts
        concepts = document.get('concepts.prefLabel', :default => '')
        concepts.size > 0 ? concepts.flatten : nil 
      end
      
    end
  end
end
