class FastapiClient
  BASE_URL = "http://127.0.0.1:8000"
  def self.request(path, payload)
    url = URI.parse(BASE_URL+path)
    req = Net::HTTP::Post.new(url)
    req["Content-Type"] = "application/json"
    req["Accept"] = "application/json"
    req.body = payload.to_json
    http = Net::HTTP.new(url.host, url.port)
    http.request(req)
  end
end
