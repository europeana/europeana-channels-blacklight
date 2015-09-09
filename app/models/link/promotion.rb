class Link::Promotion < Link
  include HasSettingsAttribute

  belongs_to :media_object, dependent: :destroy

  has_settings(:wide, :category, :class)

  delegate :file, to: :media_object
  attr_accessor :delete_file
  before_validation { self.file.clear if self.delete_file == '1' }

  delegate :settings_category_enum, to: :class
  delegate :settings_wide_enum, to: :class

  class << self
    def settings_category_enum
      %w(channel exhibition new partner featured_site)
    end

    def settings_wide_enum
      ['0', '1']
    end
  end

  validates :settings_category, inclusion: { in: settings_category_enum }, allow_nil: true, allow_blank: true
  validates :settings_wide, inclusion: { in: settings_wide_enum }, allow_nil: true

  after_initialize do
    build_media_object if self.media_object.nil?
  end
end
