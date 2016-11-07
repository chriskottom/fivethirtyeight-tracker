require "json"
require "net/http"
require "uri"

module FiveThirtyEight
  class APIResponseError < StandardError; end
  class APITimeout < APIResponseError; end

  class Feed
    SUMMARY_PATH = "http://projects.fivethirtyeight.com/2016-election-forecast/summary.json"

    def current_forecast
      json_data = fetch_feed_data
      raise APIResponseError unless json_data
      national_results = json_data.find { |item| item['state'] == 'US' }
      if !national_results
        raise APIResponseError, "No national results present in API response"
      end

      democratic_results = national_results.dig("latest", "D")
      republican_results = national_results.dig("latest", "R")

      {
        D: party_results(democratic_results),
        R: party_results(republican_results)
      }
    end

    private

    def fetch_feed_data
      uri = URI(SUMMARY_PATH)
      response = Net::HTTP.get_response(uri)
      response.body ? JSON.parse(response.body) : nil
    rescue Timeout::Error => e
      raise APITimeout, e.message
    end

    def party_results(results)
      party = results["party"]
      candidate = results["candidate"]
      probability = results.dig("models", "polls", "winprob").round(2)

      {
        party: party,
        candidate: candidate,
        probability: probability
      }
    end
  end
end
