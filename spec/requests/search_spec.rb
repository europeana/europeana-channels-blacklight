require 'rails_helper'

RSpec.describe 'Search requests', :type => :request do
  context 'without query params' do
    it 'redirects /search to /' do
      get('/search')
      expect(response).to redirect_to(root_url)
    end
  end

  context 'with q param' do
    before do
      get('/search?q=paris')
    end

    it 'searches the API' do
      expect(a_request(:get, "www.europeana.eu/api/v2/search.json").
        with(query: hash_including(query: 'paris'))).to have_been_made.at_least_once
    end

    it 'renders the search results Mustache template' do
      expect(response).to render_template('templates/Search/Search-results-list')
    end

    it 'displays the query term' do
      expect(response.body).to include('paris')
    end
  end
end
