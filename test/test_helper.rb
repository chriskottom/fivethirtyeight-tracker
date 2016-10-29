require "minitest/autorun"
require "minitest/spec"

require "fivethirtyeight_tracker"

require 'webmock/minitest'
WebMock.disable_net_connect!

require "support/json_fixtures"
require "support/fivethirtyeight_helpers"
