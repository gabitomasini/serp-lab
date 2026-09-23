# frozen_string_literal: true

module Ui
  class RequestRowComponent < ViewComponent::Base
    attr_reader :request

    def initialize(request:)
      super()
      @request = request
    end

    def latency_class
      ms = request.latency_ms || 0
      if ms < 150
        "text-emerald-400 bg-emerald-500/10 border-emerald-500/20"
      elsif ms < 300
        "text-amber-400 bg-amber-500/10 border-amber-500/20"
      else
        "text-rose-400 bg-rose-500/10 border-rose-500/20"
      end
    end

    def formatted_time
      time_ago = time_ago_in_words(request.created_at) + " ago"
      full_time = request.created_at.strftime("%H:%M:%S")
      "#{time_ago} (#{full_time})"
    end
  end
end
