require "net/http"
require "uri"
require "json"
class SpamApi
  def self.check(text)
    response = request(text)
    parse(response)
  end

  def self.request(text)
    url = URI.parse("http://127.0.0.1:8000/predict")
    req = Net::HTTP::Post.new(url)
    req["Content-Type"] = "application/json"
    req["Accept"] = "application/json"
    req.body = { text: text }.to_json
    http = Net::HTTP.new(url.host, url.port)
    http.request(req)
  end

  def self.parse(response)
    JSON.parse(response.body)
  end
end
