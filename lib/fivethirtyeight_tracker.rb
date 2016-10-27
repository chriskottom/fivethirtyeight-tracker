$: << "lib"

require "fivethirtyeight/feed"

require "ruby-progressbar"

module FiveThirtyEight
  class Tracker
    PROGRESS_MARK  = "\e[0;94m*\e[0m"
    REMAINDER_MARK = "\e[0;91m*\e[0m"
    DEFAULT_FORMAT = "  %t %P %B"

    attr_accessor :progress_bar

    def initialize
      puts
      @progress_bar = ProgressBar.create(title: title,
                                         format: DEFAULT_FORMAT,
                                         progress_mark: PROGRESS_MARK,
                                         remainder_mark: REMAINDER_MARK)
    end

    def update
      forecast = Feed.new.current_forecast

      progress_bar.title = title
      progress_bar.format = format_for_forecast(forecast)
      sleep 0.1
      progress_bar.progress = forecast.dig(:D, :probability)
    end

    private

    def title
      time_string = Time.now.strftime("%H:%M:%S")
      "\e[1m\e[93m538 Forecast (last updated #{ time_string }):\e[0m"
    end

    def format_for_forecast(forecast)
      "  %t #{ candidate_label(forecast, :D) } %B #{ candidate_label(forecast, :R) }"
    end

    def candidate_label(forecast, party)
      candidate = forecast.dig(party, :candidate)
      probability = forecast.dig(party, :probability)

      "#{ candidate } (#{  probability })"
    end
  end
end
