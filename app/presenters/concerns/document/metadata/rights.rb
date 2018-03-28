# frozen_string_literal: true

module Document
  module Metadata
    module Rights
      def rights_label_expiry(rights)
        if rights.id == :out_of_copyright_non_commercial
          end_path = URI(media_rights).path.split('/').last
          if end_path == 'out-of-copyright-non-commercial'
            nil
          else
            t('global.facet.reusability.expiry', date: end_path)
          end
        end
      end

      def simple_rights_label_data
        return nil unless media_rights.present?
        # global.facet.reusability.permission      Only with permission
        # global.facet.reusability.open            Yes with attribution
        # global.facet.reusability.restricted      Yes with restrictions
        rights = EDM::Rights.normalise(media_rights)
        simple_rights(rights)
      end

      def simple_rights(rights)
        if rights.nil?
          {
            license_public: false,
            license_name: 'unmatched rights: ' + media_rights.to_s,
            license_url: media_rights
          }
        else
          license_flag_key = rights.template_license.present? ? rights.template_license : rights.id.to_s.upcase
          simple_rights_content(rights, license_flag_key)
        end
      end

      def simple_rights_content(rights, license_flag_key)
        {
          license_restricted: rights.reusability ? rights.reusability.eql?('permission') : false,
          license_brief: t('brief', scope: "global.facet.reusability.#{rights.reusability}"),
          license_info: t('info', scope: "global.facet.reusability.#{rights.reusability}"),
          license_human: t('label', scope: "global.facet.reusability.#{rights.reusability}"),
          license_name: rights.label,
          license_url: media_rights,
          :"license_#{license_flag_key}" => true,
          expiry: rights_label_expiry(rights)
        }
      end
    end
  end
end
