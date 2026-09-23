class PlaygroundController < ApplicationController
  def index
    @query = params[:query].presence || "Ruby on Rails 8"
    @engine = params[:engine].presence || "google"
    @country = params[:country].presence || "us"

    # Grab the latest matching or create a quick initial preview
    @latest_request = ApiRequest.recent.first
    if @latest_request.present?
      @status_code = @latest_request.status_code
      @latency_ms = @latest_request.latency_ms
      @payload = @latest_request.response_payload
      @api_request = @latest_request
      @engine = @latest_request.engine
    else
      result = SearchApiService.call(query: @query, engine: @engine, country: @country)
      @status_code = result[:status_code]
      @latency_ms = result[:latency_ms]
      @payload = result[:payload]
      @api_request = result[:request]
      @engine = result[:engine]
    end

    load_metrics
  end

  def create
    @query = params[:query].presence || "site:github.com/trending"
    @raw_engine = params[:engine].presence || "google"
    @country = params[:country].presence || "us"
    force_error = params[:force_error].to_s == "1"

    result = SearchApiService.call(
      query: @query,
      engine: @raw_engine,
      country: @country,
      force_error: force_error
    )

    @api_request = result[:request]
    @status_code = result[:status_code]
    @latency_ms = result[:latency_ms]
    @payload = result[:payload]
    @engine = result[:engine]

    load_metrics

    # In Hotwire Turbo, if a turbo-frame requested this, rendering index or the frame partial works seamlessly
    render :index
  end

  private

  def load_metrics
    total = ApiRequest.count
    @total_requests = total
    @avg_latency = total.positive? ? "#{ApiRequest.average(:latency_ms).to_i}ms" : "0ms"
    success_count = ApiRequest.status_ok.count
    @success_rate = total.positive? ? "#{((success_count.to_f / total) * 100).round(1)}%" : "100%"
  end
end
