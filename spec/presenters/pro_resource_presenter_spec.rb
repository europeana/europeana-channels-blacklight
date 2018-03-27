# frozen_string_literal: true

RSpec.describe ProResourcePresenter do
  subject { described_class.new(view, resource) }

  let(:resource) { double(Pro::Base) }
  let(:last_result_set) { double(JsonApiClient::ResultSet) }
  let(:included_data) { double(JsonApiClient::IncludedData) }
  let(:view) { ApplicationView.new }

  before do
    allow(last_result_set).to receive(:included) { included_data }
    allow(resource).to receive(:last_result_set) { last_result_set }
    allow(resource).to receive(:has_taxonomy?) { true }
    allow(included_data).to receive(:has_link?) { false }
  end

  describe '#date' do
    it 'formats datepublish' do
      allow(resource).to receive(:datepublish) { '2017-02-15T14:12:00+00:00' }
      expect(subject.date).to eq('15 February, 2017')
    end
  end

  describe '#label' do
    it 'uses culturelover-theme tags to look up topics' do
      allow(resource).to receive(:taxonomy) { { tags: { '/path' => 'culturelover-fashion' } } }
      expect(subject.label).to eq('Europeana Fashion')
    end
  end

  describe '#body' do
    it 'replaces relative paths' do
      allow(Pro).to receive(:site) { 'http://www.example.com' }
      allow(resource).to receive(:body) { '<a href="/path"></a><img src="/path" />' }
      absolute = '<a href="http://www.example.com/path"></a><img src="http://www.example.com/path" />'
      expect(subject.body).to eq(absolute)
    end
  end

  describe '#excerpt' do
    let(:body) { '<p>' + ('word ' * 80).strip + '</p>' }
    before do
      allow(resource).to receive(:body) { body }
    end
    it 'truncates body to 350 chars' do
      expect(subject.excerpt.length).to be <= 350
    end
    it 'strips tags' do
      expect(subject.excerpt).not_to include('<p>')
    end
    it 'ends with ellipsis on word boundary' do
      expect(subject.excerpt).to end_with('word...')
    end
  end
end
