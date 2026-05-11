class TextModerationApi
  ENDPOINTS = {
    spam: "/predict",
    angry: "/angry"
  }
  def self.check(type, text)
    endpoint = ENDPOINTS[type]
    response = FastapiClient.request(endpoint, { text: text })
    JSON.parse(response.body)
  end
end
