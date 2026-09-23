class RequestsController < ApplicationController
  def index
    @current_status = params[:status].presence || "all"
    @requests = ApiRequest.recent.filter_by_status(@current_status)

    @all_count = ApiRequest.count
    @ok_count = ApiRequest.status_ok.count
    @error_count = ApiRequest.status_rate_limited.count
    @avg_latency = @all_count.positive? ? "#{ApiRequest.average(:latency_ms).to_i}ms" : "0ms"
    @success_rate = @all_count.positive? ? "#{((@ok_count.to_f / @all_count) * 100).round(1)}%" : "100%"
  end
end
