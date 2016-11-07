module FiveThirtyEightHelpers
  include JSONFixtures

  def stub_summary_request(options = {})
    url = "http://projects.fivethirtyeight.com/2016-election-forecast/summary.json"
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body,
                                  json_string("fivethirtyeight_summary.json"))
    stub_request(:get, url).to_return(status: status, body: response_body)
  end

  def stub_summary_timeout
    url = "http://projects.fivethirtyeight.com/2016-election-forecast/summary.json"
    stub_request(:get, url).to_timeout
  end
end
