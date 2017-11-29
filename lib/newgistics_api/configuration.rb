module NewgisticsApi
  class Configuration
    attr_accessor :api_key, :host

    def initialize
      @api_key = nil
      @host = nil
    end
  end
end
