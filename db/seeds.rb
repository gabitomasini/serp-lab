puts "Seeding SerpScope simulated API requests..."

ApiRequest.delete_all

queries = [
  { q: "ruby on rails 8 solid queue", engine: "google", country: "us", status: 200, latency: 142, hours_ago: 1 },
  { q: "hotwire turbo 8 morphing tutorial", engine: "bing", country: "br", status: 200, latency: 215, hours_ago: 2 },
  { q: "high throughput web scrapers rate_limit", engine: "google", country: "us", status: 429, latency: 54, hours_ago: 3 },
  { q: "view_component rails benchmarks", engine: "duckduckgo", country: "gb", status: 200, latency: 185, hours_ago: 4 },
  { q: "serp api latency optimization techniques", engine: "google", country: "us", status: 200, latency: 112, hours_ago: 5 },
  { q: "tailwind css v4 config guide", engine: "google", country: "de", status: 200, latency: 138, hours_ago: 6 },
  { q: "concurrent scraping crawler concurrency error_429", engine: "bing", country: "us", status: 429, latency: 68, hours_ago: 8 },
  { q: "sqlite wal mode in production rails 8", engine: "duckduckgo", country: "us", status: 200, latency: 165, hours_ago: 12 },
  { q: "stimulus js modern dialog controller", engine: "google", country: "ca", status: 200, latency: 195, hours_ago: 18 },
  { q: "propshaft asset pipeline vs sprockets", engine: "bing", country: "us", status: 200, latency: 172, hours_ago: 24 }
]

queries.each do |item|
  is_error = item[:status] == 429
  result = SerpSimulatorService.call(
    query: item[:q],
    engine: item[:engine],
    country: item[:country],
    force_error: is_error
  )

  # Update timestamp to look historical
  result[:request].update_columns(
    created_at: item[:hours_ago].hours.ago,
    updated_at: item[:hours_ago].hours.ago,
    latency_ms: item[:latency]
  )
end

puts "Seeded #{ApiRequest.count} API requests successfully!"
