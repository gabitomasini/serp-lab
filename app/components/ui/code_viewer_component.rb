# frozen_string_literal: true

module Ui
  class CodeViewerComponent < ViewComponent::Base
    attr_reader :payload, :title, :copyable, :max_height

    def initialize(payload:, title: "Response Payload", copyable: true, max_height: "max-h-[520px]")
      super()
      @payload = payload
      @title = title
      @copyable = copyable
      @max_height = max_height
    end

    def raw_json_string
      return "{}" if payload.blank?

      if payload.is_a?(String)
        begin
          JSON.pretty_generate(JSON.parse(payload))
        rescue JSON::ParserError
          payload
        end
      else
        JSON.pretty_generate(payload)
      end
    end

    def payload_size_label
      bytes = raw_json_string.bytesize
      if bytes < 1024
        "#{bytes} B"
      else
        "#{(bytes / 1024.0).round(2)} KB"
      end
    end

    def syntax_highlighted_lines
      # Generate lightweight syntax highlighted HTML for each line of JSON
      raw_json_string.lines.map do |line|
        highlight_line(line)
      end
    end

    private

    def highlight_line(line)
      escaped = ERB::Util.html_escape(line)

      # Key: "key":
      escaped = escaped.gsub(/"([^"]+)":/) do
        %Q(<span class="text-indigo-400 font-semibold">"#{$1}"</span>:)
      end

      # String value: : "val"
      escaped = escaped.gsub(/:\s*"([^"]*)"/) do
        %Q(: <span class="text-emerald-300">"#{$1}"</span>)
      end

      # Numeric value
      escaped = escaped.gsub(/:\s*(-?\d+(\.\d+)?)/) do
        %Q(: <span class="text-amber-300">#{$1}</span>)
      end

      # Boolean / null
      escaped = escaped.gsub(/:\s*(true|false|null)/) do
        %Q(: <span class="text-violet-400 font-medium">#{$1}</span>)
      end

      escaped.html_safe
    end
  end
end
