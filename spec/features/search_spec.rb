require 'rails_helper'

RSpec.feature 'Search page', :type => :feature do
  describe 'search page' do
    it 'expects results', js: true do
      visit '/'
      expect(page).to have_css('input[name=q]')
      fill_in('q', with: 'Paris')

      expect(page).to have_css('.searchbar button.search-submit')
      
      page.execute_script '$(".searchbar button.search-submit").trigger("click")'
      
      sleep 2

      list_present = page.evaluate_script '$(".results-list").length > 0'
      expect(list_present).to be true
      
      # This won't work until we mock data
      #     
      #item_count = page.evaluate_script '$(".results-list ol.result-items li").length'
      #expect(item_count).to be_between(1, 24)
      
    end
    
    it 'expects no results', js: true do
      visit '/'
      expect(page).to have_css('input[name=q]')
      fill_in('q', with: 'XXXPARISXXX')

      expect(page).to have_css('.searchbar button.search-submit')

      page.execute_script '$(".searchbar button.search-submit").trigger("click")'
      
      sleep 2

      item_count = page.evaluate_script '$(".results-list ol.result-items li").length'
      expect(item_count).to be 0
    end
  end
end
