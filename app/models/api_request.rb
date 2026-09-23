class ApiRequest < ApplicationRecord
  validates :query, presence: true
  validates :engine, presence: true
  validates :status_code, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :status_ok, -> { where(status_code: 200) }
  scope :status_rate_limited, -> { where(status_code: 429) }
  scope :filter_by_status, ->(status) {
    case status.to_s
    when "200" then status_ok
    when "429" then status_rate_limited
    else all
    end
  }

  def success?
    status_code == 200
  end

  def rate_limited?
    status_code == 429
  end

  def latency_label
    "#{latency_ms || 0}ms"
  end

  def formatted_payload
    return "{}" if response_payload.blank?
    if response_payload.is_a?(String)
      JSON.pretty_generate(JSON.parse(response_payload))
    else
      JSON.pretty_generate(response_payload)
    end
  rescue JSON::ParserError
    response_payload.to_s
  end
end
