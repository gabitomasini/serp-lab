# frozen_string_literal: true

module Ui
  class StatCardComponent < ViewComponent::Base
    attr_reader :title, :value, :subtext, :trend, :trend_positive, :icon

    def initialize(title:, value:, subtext: nil, trend: nil, trend_positive: true, icon: nil)
      super()
      @title = title
      @value = value
      @subtext = subtext
      @trend = trend
      @trend_positive = trend_positive
      @icon = icon
    end
  end
end
