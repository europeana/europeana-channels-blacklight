# frozen_string_literal: true

##
# Configure the stache gem
#
# @see https://github.com/agoragames/stache
Stache.configure do |c|
  # Store compiled templates in memory
  # (stache template cache does not work with Redis; see
  # https://github.com/agoragames/stache/issues/58)
  c.template_cache = ActiveSupport::Cache::MemoryStore.new
end
