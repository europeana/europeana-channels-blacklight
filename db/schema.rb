# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171206084927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banner_translations", force: :cascade do |t|
    t.integer  "banner_id",              null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "title",      limit: 255
    t.text     "body"
  end

  add_index "banner_translations", ["banner_id"], name: "index_banner_translations_on_banner_id", using: :btree
  add_index "banner_translations", ["locale"], name: "index_banner_translations_on_locale", using: :btree

  create_table "banners", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "state",      default: 0
    t.boolean  "default",    default: false
  end

  add_index "banners", ["default"], name: "index_banners_on_default", using: :btree

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.string   "user_type",     limit: 255
    t.string   "document_id",   limit: 255
    t.string   "title",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_type", limit: 255
  end

  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

  create_table "browse_entries", force: :cascade do |t|
    t.text     "query"
    t.integer  "media_object_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "state",               default: 0
    t.integer  "subject_type"
    t.string   "type"
    t.string   "facet_value"
    t.integer  "facet_link_group_id"
  end

  add_index "browse_entries", ["media_object_id"], name: "index_browse_entries_on_media_object_id", using: :btree
  add_index "browse_entries", ["subject_type"], name: "index_browse_entries_on_subject_type", using: :btree

  create_table "browse_entries_collections", force: :cascade do |t|
    t.integer "browse_entry_id"
    t.integer "collection_id"
  end

  create_table "browse_entry_translations", force: :cascade do |t|
    t.integer  "browse_entry_id",             null: false
    t.string   "locale",          limit: 255, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title",           limit: 255
  end

  add_index "browse_entry_translations", ["browse_entry_id"], name: "index_browse_entry_translations_on_browse_entry_id", using: :btree
  add_index "browse_entry_translations", ["locale"], name: "index_browse_entry_translations_on_locale", using: :btree

  create_table "categorisations", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "categorisable_id"
    t.string   "categorisable_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "categorisations", ["categorisable_type", "categorisable_id"], name: "index_categorisations_on_categorisable", using: :btree
  add_index "categorisations", ["topic_id"], name: "index_categorisations_on_topic_id", using: :btree

  create_table "collection_translations", force: :cascade do |t|
    t.integer  "collection_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "title"
  end

  add_index "collection_translations", ["collection_id"], name: "index_collection_translations_on_collection_id", using: :btree
  add_index "collection_translations", ["locale"], name: "index_collection_translations_on_locale", using: :btree

  create_table "collections", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.text     "api_params"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "state",                  default: 0
    t.string   "title"
    t.text     "settings"
  end

  create_table "data_provider_logos", force: :cascade do |t|
    t.integer  "data_provider_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "data_provider_logos", ["data_provider_id"], name: "index_data_provider_logos_on_data_provider_id", using: :btree

  create_table "data_providers", force: :cascade do |t|
    t.string   "name"
    t.string   "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "data_providers", ["name"], name: "index_data_providers_on_name", unique: true, using: :btree
  add_index "data_providers", ["uri"], name: "index_data_providers_on_uri", unique: true, using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "facet_link_groups", force: :cascade do |t|
    t.string   "facet_field"
    t.integer  "facet_values_count"
    t.boolean  "thumbnails"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "federation_configs", force: :cascade do |t|
    t.integer  "collection_id", null: false
    t.string   "provider",      null: false
    t.string   "context_query"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "federation_configs", ["collection_id", "provider"], name: "index_federation_configs_on_collection_id_and_provider", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "feeds", ["slug"], name: "index_feeds_on_slug", using: :btree

  create_table "feeds_pages", id: false, force: :cascade do |t|
    t.integer "feed_id", null: false
    t.integer "page_id", null: false
  end

  add_index "feeds_pages", ["feed_id", "page_id"], name: "index_feeds_pages_on_feed_id_and_page_id", using: :btree
  add_index "feeds_pages", ["page_id", "feed_id"], name: "index_feeds_pages_on_page_id_and_feed_id", using: :btree

  create_table "galleries", force: :cascade do |t|
    t.integer  "state",        default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "slug"
    t.datetime "published_at"
    t.integer  "published_by"
  end

  add_index "galleries", ["published_by"], name: "index_galleries_on_published_by", using: :btree
  add_index "galleries", ["slug"], name: "index_galleries_on_slug", unique: true, using: :btree
  add_index "galleries", ["state"], name: "index_galleries_on_state", using: :btree

  create_table "gallery_images", force: :cascade do |t|
    t.integer  "gallery_id"
    t.string   "europeana_record_id"
    t.integer  "position"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "gallery_images", ["position"], name: "index_gallery_images_on_position", using: :btree

  create_table "gallery_translations", force: :cascade do |t|
    t.integer  "gallery_id",  null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.text     "description"
  end

  add_index "gallery_translations", ["gallery_id"], name: "index_gallery_translations_on_gallery_id", using: :btree
  add_index "gallery_translations", ["locale"], name: "index_gallery_translations_on_locale", using: :btree

  create_table "hero_images", force: :cascade do |t|
    t.integer  "media_object_id"
    t.string   "license",         limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "settings"
  end

  add_index "hero_images", ["media_object_id"], name: "fk_rails_491dc63aec", using: :btree

  create_table "link_translations", force: :cascade do |t|
    t.integer  "link_id",                null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "text"
  end

  add_index "link_translations", ["link_id"], name: "index_link_translations_on_link_id", using: :btree
  add_index "link_translations", ["locale"], name: "index_link_translations_on_locale", using: :btree

  create_table "links", force: :cascade do |t|
    t.text     "url"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "type",            limit: 255
    t.text     "settings"
    t.integer  "linkable_id"
    t.string   "linkable_type",   limit: 255
    t.integer  "position"
    t.integer  "media_object_id"
  end

  add_index "links", ["linkable_type", "linkable_id"], name: "index_links_on_linkable_type_and_linkable_id", using: :btree
  add_index "links", ["media_object_id"], name: "index_links_on_media_object_id", using: :btree

  create_table "media_objects", force: :cascade do |t|
    t.text     "source_url"
    t.string   "source_url_hash",   limit: 32
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "file_fingerprint",  limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "media_objects", ["source_url_hash"], name: "index_media_objects_on_source_url_hash", using: :btree

  create_table "page_elements", force: :cascade do |t|
    t.integer "page_id"
    t.integer "positionable_id"
    t.string  "positionable_type"
    t.integer "position"
  end

  add_index "page_elements", ["position"], name: "index_page_elements_on_position", using: :btree
  add_index "page_elements", ["positionable_id", "positionable_type"], name: "index_page_elements_on_positionable_id_and_positionable_type", using: :btree

  create_table "page_translations", force: :cascade do |t|
    t.integer  "page_id",                null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "title",      limit: 255
    t.text     "body"
    t.string   "strapline"
  end

  add_index "page_translations", ["locale"], name: "index_page_translations_on_locale", using: :btree
  add_index "page_translations", ["page_id"], name: "index_page_translations_on_page_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.integer  "hero_image_id"
    t.string   "slug",           limit: 255
    t.integer  "state",                      default: 0
    t.string   "type",           limit: 255
    t.integer  "http_code"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "banner_id"
    t.text     "settings"
    t.string   "strapline"
    t.string   "newsletter_url"
    t.integer  "collection_id"
  end

  add_index "pages", ["banner_id"], name: "index_pages_on_banner_id", using: :btree
  add_index "pages", ["collection_id"], name: "index_pages_on_collection_id", using: :btree
  add_index "pages", ["hero_image_id"], name: "index_pages_on_hero_image_id", using: :btree
  add_index "pages", ["http_code"], name: "index_pages_on_http_code", using: :btree
  add_index "pages", ["slug"], name: "index_pages_on_slug", using: :btree
  add_index "pages", ["state"], name: "index_pages_on_state", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "permissionable_id"
    t.string   "permissionable_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "permissions", ["permissionable_type", "permissionable_id"], name: "index_permissions_on_permissionable", using: :btree
  add_index "permissions", ["user_id"], name: "index_permissions_on_user_id", using: :btree

  create_table "searches", force: :cascade do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.string   "user_type",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "topic_translations", force: :cascade do |t|
    t.integer  "topic_id",   null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "label"
  end

  add_index "topic_translations", ["locale"], name: "index_topic_translations_on_locale", using: :btree
  add_index "topic_translations", ["topic_id"], name: "index_topic_translations_on_topic_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "slug"
    t.text     "entity_uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topics", ["slug"], name: "index_topics_on_slug", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest",                              default: false
    t.string   "role",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", limit: 255, null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255, null: false
    t.integer  "item_id",                    null: false
    t.string   "event",          limit: 255, null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  add_foreign_key "browse_entries", "facet_link_groups"
  add_foreign_key "browse_entries_collections", "browse_entries"
  add_foreign_key "browse_entries_collections", "collections"
  add_foreign_key "categorisations", "topics"
  add_foreign_key "facet_link_groups", "pages"
  add_foreign_key "federation_configs", "collections"
  add_foreign_key "galleries", "users", column: "published_by"
  add_foreign_key "gallery_images", "galleries"
  add_foreign_key "page_elements", "pages"
  add_foreign_key "pages", "banners"
  add_foreign_key "pages", "collections"
  add_foreign_key "permissions", "users"
end
