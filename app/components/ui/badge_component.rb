# frozen_string_literal: true

module Ui
  class BadgeComponent < ViewComponent::Base
    attr_reader :variant, :value, :label

    def initialize(variant: :status, value: nil, label: nil)
      super()
      @variant = variant.to_sym
      @value = value
      @label = label || default_label
    end

    def default_label
      case variant
      when :status
        case value.to_i
        when 200 then "200 OK"
        when 429 then "429 RATE LIMIT"
        when 500 then "500 ERROR"
        else "#{value} HTTP"
        end
      when :engine
        value.to_s.titleize
      else
        value.to_s
      end
    end

    def badge_classes
      base = "inline-flex items-center gap-1.5 px-2 py-0.5 rounded-md text-xs font-mono font-medium tracking-tight"
      case variant
      when :status
        case value.to_i
        when 200
          "#{base} bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 shadow-xs"
        when 429
          "#{base} bg-amber-500/10 text-amber-400 border border-amber-500/20 shadow-xs"
        else
          "#{base} bg-rose-500/10 text-rose-400 border border-rose-500/20 shadow-xs"
        end
      when :engine
        case value.to_s.downcase
        when "google"
          "#{base} bg-blue-500/10 text-blue-400 border border-blue-500/20"
        when "bing"
          "#{base} bg-cyan-500/10 text-cyan-400 border border-cyan-500/20"
        when "duckduckgo"
          "#{base} bg-orange-500/10 text-orange-400 border border-orange-500/20"
        else
          "#{base} bg-slate-800 text-slate-300 border border-slate-700"
        end
      else
        "#{base} bg-slate-800 text-slate-300 border border-slate-700"
      end
    end

    def status_dot_classes
      case value.to_i
      when 200 then "bg-emerald-400"
      when 429 then "bg-amber-400"
      else "bg-rose-400"
      end
    end
  end
end
