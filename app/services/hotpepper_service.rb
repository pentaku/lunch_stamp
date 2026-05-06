require "net/http"
require "json"

class HotpepperService
  API_URL = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"

  def self.search(keyword: "", genre: "", budget: "")
    uri = URI(API_URL)
    params = {
      key:    Rails.application.credentials.hotpepper[:api_key],
      format: "json",
      count:  20
    }
    params[:keyword] = keyword.gsub("　", " ") if keyword.present?
    params[:genre]   = genre                   if genre.present?
    params[:budget]  = budget                  if budget.present?

    uri.query = URI.encode_www_form(params)
    data = fetch(uri)
    data.dig("results", "shop") || []
  end

  def self.find(hotpepper_id)
    uri = URI(API_URL)
    params = {
      key:    Rails.application.credentials.hotpepper[:api_key],
      id:     hotpepper_id,
      format: "json",
      count:  1
    }

    uri.query = URI.encode_www_form(params)
    data = fetch(uri)
    data.dig("results", "shop")&.first
  end

  def self.fetch(uri)
    http_options = {
      use_ssl:      true,
      open_timeout: 5,
      read_timeout: 5
    }

    # NOTE: 開発環境でSSL証明書検証エラーが発生するため一時的に無効化
    # 本番環境ではデフォルトのVERIFY_PEERが適用される
    if Rails.env.development?
      http_options[:verify_mode] = OpenSSL::SSL::VERIFY_NONE
    end

    response = Net::HTTP.start(uri.host, uri.port, **http_options) do |http|
      http.get(uri.request_uri)
    end

    return {} unless response.is_a?(Net::HTTPSuccess)
    JSON.parse(response.body)
  rescue => e
    Rails.logger.error("[HotpepperService] API Error: #{e.message}")
    {}
  end

  private_class_method :fetch
end