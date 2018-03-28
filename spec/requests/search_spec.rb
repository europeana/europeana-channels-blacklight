# frozen_string_literal: true

RSpec.describe 'Search requests' do
  context 'without query params' do
    it 'redirects /en/search to /en/' do
      get('/en/search')
      expect(response).to redirect_to(home_url)
    end
  end

  context 'with q param' do
    before do
      get('/en/search?q=paris')
    end

    it 'searches the API' do
      expect(a_request(:get, Europeana::API.url + '/v2/search.json').
        with(query: hash_including(query: 'paris'))).to have_been_made.at_least_once
    end

    it 'renders the search results Mustache template' do
      expect(response).to render_template('portal/index')
    end

    it 'displays the query term' do
      expect(response.body).to include('paris')
    end
  end
end
