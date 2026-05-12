require "net/http"

class FastapiClient
  BASE_URL = "http://127.0.0.1:8000"

  def self.request(path, payload)
    uri = URI.parse("#{BASE_URL}#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri, "Content-Type" => "application/json", "Accept" => "application/json")
    request.body = payload.to_json
    http.request(request)
  end
end
