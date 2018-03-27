# frozen_string_literal: true

RSpec.feature 'Top navigation' do
  [false, true].each do |js|
    context (js ? 'with JS' : 'without JS'), js: js do
      let(:nav) { page.find('#main-menu') }

      it 'has top nav' do
        visit '/en'
        expect(nav).not_to be_nil
      end

      it 'does not link to home' do
        visit '/en'
        expect(nav).not_to have_link('Home')
      end

      it 'links to Collections' do
        visit '/en'
        expect(nav).to have_css('span', text: 'Collections')
      end

      it 'links to exhibitions' do
        visit '/en'
        expect(nav).to have_link('Exhibitions')
      end

      it 'links to blogs' do
        visit '/en'
        expect(nav).to have_link('Blog', href: 'http://blog.europeana.eu/')
      end
    end
  end
end
