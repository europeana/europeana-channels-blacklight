# frozen_string_literal: true

RSpec.describe Ability do
  it 'uses CanCan' do
    expect(described_class).to include(CanCan::Ability)
  end

  let(:draft_banner) { banners(:draft_banner) }
  let(:published_banner) { banners(:default_banner) }
  let(:draft_collection) { collections(:draft) }
  let(:published_collection) { collections(:music) }
  let(:draft_gallery) { galleries(:draft) }
  let(:published_gallery) { galleries(:curated_gallery) }
  let(:draft_landing_page) { pages(:draft_landing_page) }
  let(:published_landing_page) { pages(:music_collection) }
  let(:landing_page_with_editor_permissions) { pages(:fashion_collection) }
  let(:gallery_with_editor_permissions) { galleries(:fashion_dresses) }
  let(:browse_entry_with_editor_permissions) { browse_entries(:paintings_topic) }

  context 'without user role (guest)' do
    subject { users(:guest) }

    it { is_expected.not_to be_able_to(:access, :rails_admin) }

    it { is_expected.not_to be_able_to(:dashboard, nil) }

    it { is_expected.not_to be_able_to(:manage, Banner.new) }
    it { is_expected.not_to be_able_to(:manage, BrowseEntry.new) }
    it { is_expected.not_to be_able_to(:manage, Collection.new) }
    it { is_expected.not_to be_able_to(:manage, DataProvider.new) }
    it { is_expected.not_to be_able_to(:manage, Feed.new) }
    it { is_expected.not_to be_able_to(:manage, Gallery.new) }
    it { is_expected.not_to be_able_to(:manage, HeroImage.new) }
    it { is_expected.not_to be_able_to(:manage, Page.new) }
    it { is_expected.not_to be_able_to(:manage, Page::Error.new) }
    it { is_expected.not_to be_able_to(:manage, Page::Landing.new) }
    it { is_expected.not_to be_able_to(:manage, Link.new) }
    it { is_expected.not_to be_able_to(:manage, MediaObject.new) }
    it { is_expected.not_to be_able_to(:manage, Topic.new) }
    it { is_expected.not_to be_able_to(:manage, User.new) }

    it { is_expected.not_to be_able_to(:show, draft_banner) }
    it { is_expected.to be_able_to(:show, published_banner) }
    it { is_expected.not_to be_able_to(:show, draft_collection) }
    it { is_expected.to be_able_to(:show, published_collection) }
    it { is_expected.not_to be_able_to(:show, draft_gallery) }
    it { is_expected.to be_able_to(:show, published_gallery) }
    it { is_expected.not_to be_able_to(:show, draft_landing_page) }
    it { is_expected.to be_able_to(:show, published_landing_page) }
  end

  context 'when user role is "user"' do
    subject { users(:user) }

    it { is_expected.not_to be_able_to(:access, :rails_admin) }

    it { is_expected.not_to be_able_to(:dashboard, nil) }

    it { is_expected.not_to be_able_to(:manage, Banner.new) }
    it { is_expected.not_to be_able_to(:manage, BrowseEntry.new) }
    it { is_expected.not_to be_able_to(:manage, Collection.new) }
    it { is_expected.not_to be_able_to(:manage, DataProvider.new) }
    it { is_expected.not_to be_able_to(:manage, Feed.new) }
    it { is_expected.not_to be_able_to(:manage, Gallery.new) }
    it { is_expected.not_to be_able_to(:manage, HeroImage.new) }
    it { is_expected.not_to be_able_to(:manage, Page.new) }
    it { is_expected.not_to be_able_to(:manage, Page::Error.new) }
    it { is_expected.not_to be_able_to(:manage, Page::Landing.new) }
    it { is_expected.not_to be_able_to(:manage, Link.new) }
    it { is_expected.not_to be_able_to(:manage, MediaObject.new) }
    it { is_expected.not_to be_able_to(:manage, Topic.new) }
    it { is_expected.not_to be_able_to(:manage, User.new) }

    it { is_expected.not_to be_able_to(:update, landing_page_with_editor_permissions) }
    it { is_expected.not_to be_able_to(:update, gallery_with_editor_permissions) }
    it { is_expected.not_to be_able_to(:update, browse_entry_with_editor_permissions) }
    it { is_expected.not_to be_able_to(:publish, gallery_with_editor_permissions) }
    it { is_expected.not_to be_able_to(:publish, browse_entry_with_editor_permissions) }
    it { is_expected.not_to be_able_to(:unpublish, gallery_with_editor_permissions) }
    it { is_expected.not_to be_able_to(:unpublish, browse_entry_with_editor_permissions) }

    it { is_expected.not_to be_able_to(:show, draft_banner) }
    it { is_expected.to be_able_to(:show, published_banner) }
    it { is_expected.not_to be_able_to(:show, draft_collection) }
    it { is_expected.to be_able_to(:show, published_collection) }
    it { is_expected.not_to be_able_to(:show, draft_gallery) }
    it { is_expected.to be_able_to(:show, published_gallery) }
    it { is_expected.not_to be_able_to(:show, draft_landing_page) }
    it { is_expected.to be_able_to(:show, published_landing_page) }
  end

  context 'when user role is "editor"' do
    subject { users(:editor) }

    it { is_expected.to be_able_to(:access, :rails_admin) }

    it { is_expected.to be_able_to(:dashboard, nil) }

    it { is_expected.to be_able_to(:read, Banner.new) }
    it { is_expected.to be_able_to(:read, BrowseEntry.new) }
    it { is_expected.to be_able_to(:read, Collection.new) }
    it { is_expected.to be_able_to(:read, DataProvider.new) }
    it { is_expected.to be_able_to(:read, Feed.new) }
    it { is_expected.to be_able_to(:read, Gallery.new) }
    it { is_expected.to be_able_to(:read, HeroImage.new) }
    it { is_expected.to be_able_to(:read, Page.new) }
    it { is_expected.to be_able_to(:read, Page::Error.new) }
    it { is_expected.to be_able_to(:read, Page::Landing.new) }
    it { is_expected.to be_able_to(:read, Link.new) }
    it { is_expected.to be_able_to(:read, MediaObject.new) }
    it { is_expected.to be_able_to(:read, Topic.new) }
    it { is_expected.to be_able_to(:read, User.new) }

    it { is_expected.not_to be_able_to(:create, Banner.new) }
    it { is_expected.to be_able_to(:create, BrowseEntry.new) }
    it { is_expected.not_to be_able_to(:create, Collection.new) }
    it { is_expected.not_to be_able_to(:create, DataProvider.new) }
    it { is_expected.not_to be_able_to(:create, Feed.new) }
    it { is_expected.to be_able_to(:create, Gallery.new) }
    it { is_expected.not_to be_able_to(:create, HeroImage.new) }
    it { is_expected.not_to be_able_to(:create, Page.new) }
    it { is_expected.not_to be_able_to(:create, Page::Error.new) }
    it { is_expected.not_to be_able_to(:create, Page::Landing.new) }
    it { is_expected.not_to be_able_to(:create, Link.new) }
    it { is_expected.not_to be_able_to(:create, MediaObject.new) }
    it { is_expected.not_to be_able_to(:create, Topic.new) }
    it { is_expected.not_to be_able_to(:create, User.new) }

    it { is_expected.not_to be_able_to(:update, Banner.new) }
    it { is_expected.not_to be_able_to(:update, BrowseEntry.new) }
    it { is_expected.not_to be_able_to(:update, Collection.new) }
    it { is_expected.to be_able_to(:update, DataProvider.new) }
    it { is_expected.not_to be_able_to(:update, Feed.new) }
    it { is_expected.not_to be_able_to(:update, Gallery.new) }
    it { is_expected.to be_able_to(:update, HeroImage.new) }
    it { is_expected.not_to be_able_to(:update, Page.new) }
    it { is_expected.not_to be_able_to(:update, Page::Error.new) }
    it { is_expected.not_to be_able_to(:update, Page::Landing.new) }
    it { is_expected.not_to be_able_to(:update, Link.new) }
    it { is_expected.to be_able_to(:update, MediaObject.new) }
    it { is_expected.not_to be_able_to(:update, Topic.new) }
    it { is_expected.not_to be_able_to(:update, User.new) }

    it { is_expected.to be_able_to(:update, landing_page_with_editor_permissions) }
    it { is_expected.to be_able_to(:update, gallery_with_editor_permissions) }
    it { is_expected.to be_able_to(:update, browse_entry_with_editor_permissions) }
    it { is_expected.to be_able_to(:publish, gallery_with_editor_permissions) }
    it { is_expected.to be_able_to(:publish, browse_entry_with_editor_permissions) }
    it { is_expected.to be_able_to(:unpublish, gallery_with_editor_permissions) }
    it { is_expected.to be_able_to(:unpublish, browse_entry_with_editor_permissions) }

    it { is_expected.to be_able_to(:show, draft_banner) }
    it { is_expected.to be_able_to(:show, published_banner) }
    it { is_expected.to be_able_to(:show, draft_collection) }
    it { is_expected.to be_able_to(:show, published_collection) }
    it { is_expected.to be_able_to(:show, draft_gallery) }
    it { is_expected.to be_able_to(:show, published_gallery) }
    it { is_expected.to be_able_to(:show, draft_landing_page) }
    it { is_expected.to be_able_to(:show, published_landing_page) }
  end

  context 'when user role is "admin"' do
    subject { users(:admin) }

    it { is_expected.to be_able_to(:access, :rails_admin) }
    it { is_expected.to be_able_to(:dashboard, nil) }

    it { is_expected.to be_able_to(:manage, Banner.new) }
    it { is_expected.to be_able_to(:manage, BrowseEntry.new) }
    it { is_expected.to be_able_to(:manage, Collection.new) }
    it { is_expected.to be_able_to(:manage, DataProvider.new) }
    it { is_expected.to be_able_to(:manage, Feed.new) }
    it { is_expected.to be_able_to(:manage, Gallery.new) }
    it { is_expected.to be_able_to(:manage, HeroImage.new) }
    it { is_expected.to be_able_to(:manage, Page.new) }
    it { is_expected.to be_able_to(:manage, Page::Error.new) }
    it { is_expected.to be_able_to(:manage, Page::Landing.new) }
    it { is_expected.to be_able_to(:manage, Link.new) }
    it { is_expected.to be_able_to(:manage, MediaObject.new) }
    it { is_expected.to be_able_to(:manage, Topic.new) }
    it { is_expected.to be_able_to(:manage, User.new) }

    it { is_expected.to be_able_to(:manage, landing_page_with_editor_permissions) }
    it { is_expected.to be_able_to(:manage, gallery_with_editor_permissions) }
    it { is_expected.to be_able_to(:manage, browse_entry_with_editor_permissions) }

    it { is_expected.to be_able_to(:show, draft_banner) }
    it { is_expected.to be_able_to(:show, published_banner) }
    it { is_expected.to be_able_to(:show, draft_collection) }
    it { is_expected.to be_able_to(:show, published_collection) }
    it { is_expected.to be_able_to(:show, draft_gallery) }
    it { is_expected.to be_able_to(:show, published_gallery) }
    it { is_expected.to be_able_to(:show, draft_landing_page) }
    it { is_expected.to be_able_to(:show, published_landing_page) }
  end

  describe '#needs_permission?' do
    context 'when the user is an editor' do
      subject { users(:editor) }
      it 'should be true' do
        expect(subject.ability.needs_permission?).to eq(true)
      end
    end
    context 'when the user is a user' do
      subject { users(:user) }
      it 'should be false' do
        expect(subject.ability.needs_permission?).to eq(false)
      end
    end
    context 'when the user is an admin' do
      subject { users(:admin) }
      it 'should be false' do
        expect(subject.ability.needs_permission?).to eq(false)
      end
    end
  end
end
