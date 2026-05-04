require "net/http"
require "json"

class HotpepperService
  API_URL = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"

  def self.search(keyword)
    uri = URI(API_URL)
    uri.query = URI.encode_www_form(
      key:     Rails.application.credentials.hotpepper[:api_key],
      keyword: keyword,
      format:  "json",
      count:   20
    )

    begin
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 5) do |http|
        http.get(uri.request_uri)
      end
      return [] unless response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data.dig("results", "shop") || []
    rescue => e
      Rails.logger.error("Hotpepper API Error: #{e.message}")
      []
    end
  end
end