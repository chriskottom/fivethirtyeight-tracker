require "test_helper"

describe FiveThirtyEight::Feed do
  include FiveThirtyEightHelpers

  let(:feed) { FiveThirtyEight::Feed.new }

  describe "when the API delivers a successful response" do
    before do
      @stub_api = stub_summary_request
    end

    it "requests data from the API" do
      feed.current_forecast
      assert_requested @stub_api
    end

    it "delivers a simplified result set from the complete feed" do
      forecast = feed.current_forecast

      expect(forecast.dig(:D, :party)).must_equal "D"
      expect(forecast.dig(:D, :candidate)).must_equal "Clinton"
      expect(forecast.dig(:D, :probability)).must_equal 80.0

      expect(forecast.dig(:R, :party)).must_equal "R"
      expect(forecast.dig(:R, :candidate)).must_equal "Trump"
      expect(forecast.dig(:R, :probability)).must_equal 20.0
    end
  end

  describe "when the response has no body string" do
    before do
      stub_summary_request(status: 404, response_body: '')
    end

    it "raises an APIResponseError" do
      assert_raises(FiveThirtyEight::APIResponseError) do
        feed.current_forecast
      end
    end
  end

  describe "when the request times out" do
    before do
      stub_summary_timeout
    end

    it "raises an APITimeout" do
      assert_raises(FiveThirtyEight::APITimeout) do
        feed.current_forecast
      end
    end
  end
end
