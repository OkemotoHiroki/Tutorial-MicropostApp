require "net/http"

class FastapiClient
  BASE_URL = ENV.fetch("MODERATION_API_BASE_URL", "http://127.0.0.1:8000")

  def self.request(path, payload)
    uri = URI.parse("#{BASE_URL}#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    request = Net::HTTP::Post.new(uri, "Content-Type" => "application/json", "Accept" => "application/json")
    request.body = payload.to_json

    response = http.request(request)
    if response.is_a?(Net::HTTPSuccess)
      Rails.logger.info("[FastapiClient] POST #{uri} -> #{response.code}")
    else
      Rails.logger.error("[FastapiClient] POST #{uri} -> #{response.code} #{response.message} body=#{response.body}")
    end
    response
  rescue => e
    Rails.logger.error("[FastapiClient] POST #{uri} failed: #{e.class}: #{e.message}")
    raise
  end
end
