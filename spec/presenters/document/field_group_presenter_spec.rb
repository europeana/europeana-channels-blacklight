# TODO: establish why "# frozen_string_literal: true" here fails in
#       `Europeana::Blacklight::Response#force_encoding`.

RSpec.describe Document::FieldGroupPresenter, presenter: :field_group do
  let(:controller) { CatalogController.new }
  let(:bl_response) { Europeana::Blacklight::Response.new(api_response, {}) }
  let(:document) { bl_response.documents.first }
  let(:basic_api_response) { JSON.parse(api_responses(:record, id: 'abc/123')) }
  let(:api_response) { basic_api_response }
  let(:field_group_id) { :test_field }

  before do
    allow(described_class).to receive(:definition).with(field_group_id).and_return(field_definition)
  end

  describe '#display' do
    subject { described_class.new(document, controller, field_group_id).display }

    context 'when mapping values' do
      let(:field_definition) do
        {
          sections: [
            {
              fields: %(aggregations.edmUgc),
              map_values: {
                'true' => 'site.object.meta-label.ugc'
              }
            }
          ]
        }
      end
      let(:api_response) do
        basic_api_response.tap do |record|
          record['object']['aggregations'].first['edmUgc'] = field_value
        end
      end

      context 'when the value maps to another value' do
        let(:field_value) { 'true' }

        it 'maps and translate the value' do
          expect(subject[:sections].first[:items].first[:text]).to eq(I18n.t('site.object.meta-label.ugc'))
        end
      end

      context 'when the value is not mapped' do
        let(:field_value) { 'false' }

        it 'should be untouched' do
          expect(subject[:sections].first[:items].first[:text]).to eq(field_value)
        end
      end
    end

    context 'with excluded values' do
      let(:excluded_values) { %w(history art) }
      let(:field_definition) do
        {
          sections: [
            {
              exclude_vals: excluded_values,
              fields: 'proxies.dcSubject'
            }
          ]
        }
      end
      let(:api_response) do
        basic_api_response.tap do |record|
          record['object']['proxies'].first['dcSubject'] = {
            def: %w(history music art fashion)
          }
        end
      end

      it 'removes excluded values' do
        expect(subject[:sections].first[:items].none? { |item| excluded_values.include?(item[:text]) }).to be true
      end

      it 'leaves other values' do
        expect(subject[:sections].first[:items].size).to eq(2)
      end
    end

    context 'with entities' do
      let(:entity_id) { '1234' }
      let(:field_definition) do
        {
          sections: [
            {
              entity: {
                name: entity_name
              },
              fields: %(proxies.#{proxy_field})
            }
          ]
        }
      end
      let(:api_response) do
        basic_api_response.tap do |record|
          record['object']['proxies'].first[proxy_field] = {
            def: ["http://data.europeana.eu/#{entity_type}/base/#{entity_id}"]
          }
          record['object'][entity_name] = [
            {
              about: "http://data.europeana.eu/#{entity_type}/base/#{entity_id}",
              prefLabel: { en: ['Entity label'] }
            }
          ]
        end
      end

      context 'when entity is a Europeana agent' do
        let(:entity_type) { 'agent' }
        let(:entity_name) { 'agents' }
        let(:proxy_field) { 'dcCreator' }

        it 'links to the entity page' do
          expect(subject[:sections].first[:items].first[:url]).to eq('/en/explore/people/1234-entity-label.html')
        end
      end

      context 'when entity is a Europeana concept' do
        let(:entity_type) { 'concept' }
        let(:entity_name) { 'concepts' }
        let(:proxy_field) { 'dcFormat' }

        it 'links to the entity page' do
          expect(subject[:sections].first[:items].first[:url]).to eq('/en/explore/topics/1234-entity-label.html')
        end
      end
    end
  end
end
