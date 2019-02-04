# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Gem requires
require 'cancan/matchers'
require 'capybara_helper'
require 'paper_trail/frameworks/rspec'
require 'shoulda/matchers'
require 'webmock_helper'

require 'devise'
require_relative 'support/controller_macros'

# Local requires

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # All the fixtures, all the time.
  config.global_fixtures = :all

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.include ApiResponseFixtures
  config.include CiEnvHelper
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include EuropeanaAPIHelper
  config.include RequestHelper, type: :request
  config.include ViewTestHelper, type: :view

  config.before(:suite) do
    ActiveJob::Base.queue_adapter = :test
  end

  config.before(:each) do
    Europeana::Portal::Application.config.relative_url_root = nil
    Rails.cache.clear
  end

  config.before(:suite) do
    # Rails 4.2 call `initialize` inside `recycle!`. However Ruby 2.6 doesn't allow calling `initialize` twice.
    # See for detail: https://github.com/rails/rails/issues/34790
    if RUBY_VERSION.to_f >= 2.6 && Rails::VERSION::MAJOR == 4
      class ActionController::TestResponse
        prepend Module.new {
          def recycle!
            # hack to avoid MonitorMixin double-initialize error:
            @mon_mutex_owner_object_id = nil
            @mon_mutex = nil
            super
          end
        }
      end
    end
  end

  config.extend ControllerMacros, type: :controller
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

class ActionView::TestCase::TestController
  include Catalog

  def default_url_options(_options = {})
    { locale: I18n.default_locale }
  end
end
