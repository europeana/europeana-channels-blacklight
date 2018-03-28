# frozen_string_literal: true

##
# Including view are expected to implement `paginated_set`, returning the set
# of paginated objects to render links for.
module PaginatedView
  extend ActiveSupport::Concern

  def results_range
    "#{pagination_current_page_range_from} - #{pagination_current_page_range_to}"
  end

  def results_count
    number_with_delimiter(pagination_total)
  end

  def has_results?
    mustache[:has_results] ||= begin
      pagination_page_item_count.positive?
    end
  end
  alias_method :has_results, :has_results?

  def has_single_result?
    mustache[:has_single_result] ||= begin
      pagination_page_item_count == 1
    end
  end
  alias_method :has_single_result, :has_single_result?

  def has_multiple_results?
    mustache[:has_multiple_results] ||= begin
      pagination_page_item_count > 1
    end
  end
  alias_method :has_multiple_results, :has_multiple_results?

  protected

  def pagination_current_page_range_from
    return 0 if pagination_total.zero?
    ((pagination_current_page - 1) * pagination_per_page) + 1
  end

  def pagination_current_page_range_to
    [pagination_current_page_range_from + pagination_per_page - 1, pagination_total].min
  end

  def paginated_set
    fail NotImplementedError, 'Including view class must implement #paginated_set'
  end

  def pagination_current_page
    paginated_set.current_page
  end

  def pagination_per_page
    paginated_set.limit_value
  end

  def pagination_total
    paginated_set.total
  end

  def pagination_total_pages
    paginated_set.total_pages
  end

  def pagination_page_item_count
    paginated_set.count
  end

  def pagination_first_page?
    pagination_current_page == 1
  end

  def pagination_last_page?
    pagination_current_page == pagination_total_pages
  end

  def pagination_navigation
    {
      prev_url: pagination_previous_page_url,
      next_url: pagination_next_page_url,
      is_first_page: pagination_first_page?,
      is_last_page: pagination_last_page?,
      pages: pagination_pages.collect.each_with_index do |page, i|
        {
          url: Kaminari::Helpers::Page.new(self, page: page.number).url,
          index: number_with_delimiter(page.number),
          is_current: (pagination_current_page == page.number),
          separator: show_pagination_separator?(i, page.number, pagination_pages.size)
        }
      end
    }
  end

  def pagination_pages
    mustache[:pagination_pages] ||= begin
      opts = {
        total_pages: pagination_total_pages,
        current_page: pagination_current_page,
        per_page: pagination_per_page,
        remote: false,
        window: 3
      }
      [].tap do |pages|
        Kaminari::Helpers::Paginator.new(self, opts).each_relevant_page do |p|
          pages << p
        end
      end
    end
  end

  def show_pagination_separator?(page_index, page_number, pages_shown)
    (page_index == 1 && pagination_current_page > 2) ||
      (page_index == (pages_shown - 2) && (page_number + 1) < pagination_total_pages)
  end

  def pagination_previous_page_url
    Kaminari::Helpers::PrevPage.new(self, current_page: pagination_current_page).url
  end

  def pagination_next_page_url
    Kaminari::Helpers::NextPage.new(self, current_page: pagination_current_page).url
  end
end
