require "net/http"
require "json"

class SearchApiService
  ENGINE_MAP = {
    "google" => "google",
    "shopping" => "google_shopping",
    "google_shopping" => "google_shopping",
    "youtube" => "youtube"
  }.freeze

  API_ENDPOINT = "https://www.searchapi.io/api/v1/search".freeze

  def self.call(query:, engine: "google", country: "us", force_error: false)
    new(query: query, engine: engine, country: country, force_error: force_error).execute
  end

  def initialize(query:, engine: "google", country: "us", force_error: false)
    @query = query.to_s.strip
    @raw_engine = engine.to_s.downcase
    @normalized_engine = ENGINE_MAP.fetch(@raw_engine, "google")
    @country = country.to_s.downcase.presence || "us"
    @force_error = force_error
    @api_key = ENV["SEARCHAPI_API_KEY"]
  end

  def execute
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    if @force_error
      latency_ms = rand(45..85)
      status_code = 429
      payload = build_rate_limit_payload(latency_ms)
    elsif @api_key.present?
      status_code, payload, latency_ms = fetch_live_search(start_time)
    else
      latency_ms = rand(95..220)
      status_code = 200
      payload = build_mock_payload(latency_ms)
    end

    # Fallback to mock payload if live API returned error/rate limit and user didn't explicitly force it
    if status_code != 200 && !@force_error
      status_code = 200
      payload = build_mock_payload(latency_ms)
    end

    api_request = ApiRequest.create!(
      query: @query.presence || "site:github.com/trending",
      engine: @normalized_engine,
      country: @country,
      status_code: status_code,
      latency_ms: latency_ms,
      response_payload: payload
    )

    {
      request: api_request,
      status_code: status_code,
      latency_ms: latency_ms,
      payload: payload,
      engine: @normalized_engine
    }
  end

  private

  def fetch_live_search(start_time)
    uri = URI(API_ENDPOINT)
    uri.query = URI.encode_www_form({
      engine: @normalized_engine,
      q: @query.presence || "site:github.com/trending",
      gl: @country,
      api_key: @api_key
    })

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 8
    http.read_timeout = 10

    request = Net::HTTP::Get.new(uri)
    response = http.request(request)

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    latency_ms = ((end_time - start_time) * 1000).to_i

    status_code = response.code.to_i
    payload = begin
      JSON.parse(response.body)
    rescue JSON::ParserError
      { "raw_response" => response.body }
    end

    [status_code, payload, latency_ms]
  rescue StandardError => e
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    latency_ms = ((end_time - start_time) * 1000).to_i
    [500, { "error" => e.message }, latency_ms]
  end

  def build_rate_limit_payload(latency_ms)
    {
      "error" => "Too Many Requests",
      "status_code" => 429,
      "message" => "API key concurrency limit exceeded. Retry after 60 seconds.",
      "search_parameters" => {
        "engine" => @normalized_engine,
        "q" => @query,
        "gl" => @country
      },
      "timing" => {
        "latency_ms" => latency_ms,
        "timestamp" => Time.current.iso8601
      }
    }
  end

  def build_mock_payload(latency_ms)
    case @normalized_engine
    when "google_shopping"
      build_mock_shopping_payload(latency_ms)
    when "youtube"
      build_mock_youtube_payload(latency_ms)
    else
      build_mock_google_payload(latency_ms)
    end
  end

  def build_mock_google_payload(latency_ms)
    {
      "search_metadata" => {
        "id" => "req_#{SecureRandom.hex(8)}",
        "status" => "Success",
        "engine" => "google",
        "total_time_ms" => latency_ms
      },
      "search_parameters" => {
        "engine" => "google",
        "q" => @query,
        "gl" => @country
      },
      "knowledge_graph" => {
        "title" => @query.titlecase,
        "type" => "Developer & Technology Topic",
        "description" => "Comprehensive reference, release guides, and architectural benchmarks for #{@query}."
      },
      "organic_results" => [
        {
          "position" => 1,
          "title" => "Official #{@query.titlecase} Documentation & Quickstart",
          "link" => "https://docs.serplab.dev/#{@query.parameterize}",
          "displayed_link" => "https://docs.serplab.dev › #{@query.parameterize}",
          "snippet" => "Explore production-grade deployment guides, performance patterns, and Hotwire architectural primitives for #{@query}."
        },
        {
          "position" => 2,
          "title" => "Building Reactive Web Apps with #{@query.titlecase}",
          "link" => "https://engineering.serplab.dev/posts/#{@query.parameterize}",
          "displayed_link" => "https://engineering.serplab.dev › posts",
          "snippet" => "A deep technical walkthrough demonstrating Turbo 8 morphing, ViewComponent encapsulation, and server-driven latency optimizations."
        },
        {
          "position" => 3,
          "title" => "GitHub - serplab/#{@query.parameterize}: Open Source Core",
          "link" => "https://github.com/serplab/#{@query.parameterize}",
          "displayed_link" => "https://github.com › serplab › #{@query.parameterize}",
          "snippet" => "The canonical open-source repository containing benchmarks, releases, and issue trackers."
        }
      ]
    }
  end

  def build_mock_shopping_payload(latency_ms)
    {
      "search_metadata" => {
        "id" => "shp_#{SecureRandom.hex(8)}",
        "status" => "Success",
        "engine" => "google_shopping",
        "total_time_ms" => latency_ms
      },
      "search_parameters" => {
        "engine" => "google_shopping",
        "q" => @query,
        "gl" => @country
      },
      "shopping_results" => [
        {
          "position" => 1,
          "title" => "Pro Mechanical Developer Keyboard - Wireless RGB (#{@query})",
          "product_link" => "https://store.serplab.dev/products/pro-keyboard",
          "price" => "$149.00",
          "original_price" => "$189.00",
          "rating" => 4.9,
          "reviews" => 1420,
          "seller" => "Keychron Official",
          "thumbnail" => "https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=300&auto=format&fit=crop&q=80",
          "tag" => "21% OFF"
        },
        {
          "position" => 2,
          "title" => "Ultra-Wide 34\" Curved USB-C Programming Monitor",
          "product_link" => "https://store.serplab.dev/products/curved-monitor",
          "price" => "$399.99",
          "original_price" => "$499.00",
          "rating" => 4.7,
          "reviews" => 850,
          "seller" => "LG Electronics",
          "thumbnail" => "https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=300&auto=format&fit=crop&q=80",
          "tag" => "Free Shipping"
        },
        {
          "position" => 3,
          "title" => "Ergonomic Standing Desk Frame (Dual Motor)",
          "product_link" => "https://store.serplab.dev/products/standing-desk",
          "price" => "$289.00",
          "rating" => 4.8,
          "reviews" => 640,
          "seller" => "FlexiSpot",
          "thumbnail" => "https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?w=300&auto=format&fit=crop&q=80"
        }
      ]
    }
  end

  def build_mock_youtube_payload(latency_ms)
    {
      "search_metadata" => {
        "id" => "yt_#{SecureRandom.hex(8)}",
        "status" => "Success",
        "engine" => "youtube",
        "total_time_ms" => latency_ms
      },
      "search_parameters" => {
        "engine" => "youtube",
        "q" => @query,
        "gl" => @country
      },
      "videos" => [
        {
          "position" => 1,
          "title" => "#{@query.titlecase} in 100 Seconds - Full Architectural Breakdown",
          "link" => "https://www.youtube.com/watch?v=mock1",
          "length" => "2:45",
          "channel" => {
            "title" => "Fireship",
            "link" => "https://www.youtube.com/@Fireship"
          },
          "views" => 742000,
          "published_time" => "3 months ago",
          "thumbnail" => {
            "static" => "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=480&auto=format&fit=crop&q=80"
          }
        },
        {
          "position" => 2,
          "title" => "Deep Dive into #{@query.titlecase} (Complete Production Course)",
          "link" => "https://www.youtube.com/watch?v=mock2",
          "length" => "42:18",
          "channel" => {
            "title" => "Jack Herrington",
            "link" => "https://www.youtube.com/@jherr"
          },
          "views" => 189000,
          "published_time" => "1 year ago",
          "thumbnail" => {
            "static" => "https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=480&auto=format&fit=crop&q=80"
          }
        },
        {
          "position" => 3,
          "title" => "Building Real-Time Microservices with #{@query.titlecase}",
          "link" => "https://www.youtube.com/watch?v=mock3",
          "length" => "18:04",
          "channel" => {
            "title" => "The Primeagen",
            "link" => "https://www.youtube.com/@ThePrimeagen"
          },
          "views" => 324000,
          "published_time" => "5 months ago",
          "thumbnail" => {
            "static" => "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=480&auto=format&fit=crop&q=80"
          }
        }
      ]
    }
  end
end
