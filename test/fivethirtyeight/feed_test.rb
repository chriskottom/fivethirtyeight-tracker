require "test_helper"

describe FiveThirtyEight::Feed do
  include FiveThirtyEightHelpers

  let(:feed) { FiveThirtyEight::Feed.new }

  describe "when the API delivers a successful response" do
    before do
      stub_summary_request
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
end
