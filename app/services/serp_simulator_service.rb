class SerpSimulatorService
  ENGINES = %w[google shopping youtube bing duckduckgo baidu].freeze
  COUNTRIES = %w[us br gb de fr jp ca].freeze

  KNOWLEDGE_TOPICS = {
    "ruby on rails" => {
      title: "Ruby on Rails",
      type: "Server-side web application framework",
      description: "Ruby on Rails, or Rails, is a server-side web application framework written in Ruby under the MIT License. Rails is a model–view–controller framework, providing default structures for a database, a web service, and web pages.",
      initial_release: "December 13, 2005",
      latest_release: "Rails 8.0 / 8.1",
      creator: "David Heinemeier Hansson (DHH)"
    },
    "hotwire" => {
      title: "Hotwire (HTML Over The Wire)",
      type: "Frontend Architecture Pattern",
      description: "Hotwire is an alternative approach to building modern web applications without using much JavaScript by sending HTML directly over the wire. It comprises Turbo, Stimulus, and Strada.",
      components: ["Turbo 8", "Stimulus 3", "Strada"]
    },
    "tailwind css" => {
      title: "Tailwind CSS",
      type: "Utility-first CSS Framework",
      description: "A utility-first CSS framework packed with classes like flex, pt-4, text-center and rotate-90 that can be composed to build any design, directly in your markup.",
      version: "Tailwind CSS v4"
    }
  }.freeze

  def self.call(query:, engine: "google", country: "us", force_error: false)
    new(query: query, engine: engine, country: country, force_error: force_error).execute
  end

  def initialize(query:, engine: "google", country: "us", force_error: false)
    @query = query.to_s.strip
    @engine = ENGINES.include?(engine.to_s.downcase) ? engine.to_s.downcase : "google"
    @country = COUNTRIES.include?(country.to_s.downcase) ? country.to_s.downcase : "us"
    @force_error = force_error
  end

  def execute
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    # Calculate realistic simulated latency between 95ms and 340ms
    base_latency = rand(95..280)
    latency_ms = @force_error ? rand(45..85) : base_latency

    if @force_error || @query.downcase.include?("rate_limit") || @query.downcase.include?("error_429")
      status_code = 429
      payload = build_rate_limit_payload(latency_ms)
    else
      status_code = 200
      payload = build_success_payload(latency_ms)
    end

    # Save to history
    api_request = ApiRequest.create!(
      query: @query.presence || "latest developer trends",
      engine: @engine,
      country: @country,
      status_code: status_code,
      latency_ms: latency_ms,
      response_payload: payload
    )

    {
      request: api_request,
      status_code: status_code,
      latency_ms: latency_ms,
      payload: payload
    }
  end

  private

  def build_rate_limit_payload(latency_ms)
    {
      error: "Too Many Requests",
      status_code: 429,
      message: "API key concurrency limit exceeded. Retry after 60 seconds.",
      details: {
        current_usage: 100,
        quota_limit: 100,
        reset_in_seconds: 48,
        engine: @engine,
        query: @query
      },
      timing: {
        latency_ms: latency_ms,
        timestamp: Time.current.iso8601
      }
    }
  end

  def build_success_payload(latency_ms)
    clean_q = @query.downcase
    matched_knowledge = KNOWLEDGE_TOPICS.find { |k, _| clean_q.include?(k) }&.last

    organic = [
      {
        position: 1,
        title: "#{@query.titleize} - Official Documentation & Guides",
        link: "https://#{@engine}.com/docs/#{CGI.escape(@query.parameterize)}",
        snippet: "Comprehensive guide and API documentation for #{@query}. Learn best practices, architecture details, and implementation examples.",
        displayed_link: "https://docs.serplab.dev/#{@query.parameterize}",
        sitelinks: [
          { title: "Getting Started", link: "#intro" },
          { title: "API Reference", link: "#api" },
          { title: "Release Notes", link: "#releases" }
        ]
      },
      {
        position: 2,
        title: "Building high-performance apps with #{@query.titleize}",
        link: "https://engineering.serplab.dev/posts/#{CGI.escape(@query.parameterize)}",
        snippet: "Deep dive into production deployment, zero-latency caching, Hotwire Turbo frames, and developer tooling benchmarks.",
        displayed_link: "https://engineering.serplab.dev"
      },
      {
        position: 3,
        title: "GitHub Repository: #{@query.parameterize}/core",
        link: "https://github.com/serplab/#{@query.parameterize}",
        snippet: "Open source repositories, issue trackers, discussions, and release binaries for developers.",
        displayed_link: "https://github.com/serplab"
      },
      {
        position: 4,
        title: "Community Discussions & Questions around #{@query.titleize}",
        link: "https://forum.serplab.dev/t/#{CGI.escape(@query.parameterize)}",
        snippet: "Join 15,000+ engineers discussing architecture, ViewComponent designs, and real-time observability pipelines.",
        displayed_link: "https://forum.serplab.dev"
      }
    ]

    {
      search_metadata: {
        id: "req_#{SecureRandom.hex(10)}",
        status: "Success",
        engine: @engine,
        country: @country,
        created_at: Time.current.iso8601,
        processed_at: Time.current.strftime("%Y-%m-%d %H:%M:%S UTC"),
        total_time_ms: latency_ms
      },
      search_parameters: {
        engine: @engine,
        q: @query,
        gl: @country,
        hl: "en",
        device: "desktop"
      },
      knowledge_graph: matched_knowledge,
      organic_results: organic,
      related_searches: [
        "#{@query} tutorial 2026",
        "#{@query} vs react",
        "#{@query} best practices",
        "#{@query} hotwire performance"
      ]
    }.compact
  end
end
