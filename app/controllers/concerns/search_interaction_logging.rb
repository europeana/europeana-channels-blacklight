# frozen_string_literal: true

##
# Logs search interactions
module SearchInteractionLogging
  extend ActiveSupport::Concern

  def log_search_interaction(**options)
    logger.info(search_interaction_msg(options))
  end

  def log_search_interaction_on_search(search_response)
    log_search_interaction(
      search: params.slice(:q, :qe, :qf, :f, :mlt, :range).inspect,
      total: search_response.total
    )
  end

  def log_search_interaction_on_show
    return unless referer_was_search_request? && params.key?(:l)

    log_search_interaction(
      record: params[:id],
      search: params[:l][:p].inspect,
      total: params[:l][:t],
      rank: params[:l][:r]
    )

    redirect_to url_for(params.except(:l))
  end

  def search_interaction_msg(**options)
    msg = ['Search interaction:']
    msg << "* Record: /#{options[:record]}" if options.key?(:record)
    msg << "* Search parameters: #{options[:search]}" if options.key?(:search)
    msg << "* Total hits: #{options[:total]}" if options.key?(:total)
    msg << "* Result rank: #{options[:rank]}" if options.key?(:rank)
    msg.join("\n")
  end

  def current_page_is_search_request?
    search_request?(current_path)
  end

  def search_urls
    [search_url] + displayable_collections.map { |c| collection_url(c) }
  end

  def referer_was_search_request?
    search_request?(request.referer)
  end

  def search_request?(url)
    return false unless url.present?
    search_urls.any? { |u| url.match "^#{u}(\\?|$)" }
  end
end
