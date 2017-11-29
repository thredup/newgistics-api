require "newgistics_api/version"
require "newgistics_api/configuration"

module NewgisticsApi
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require "newgistics_api/exceptions/not_found_shipment_error"
require "newgistics_api/client"
require "newgistics_api/shipment"
require "newgistics_api/tracking"
