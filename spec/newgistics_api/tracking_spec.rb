require "spec_helper"

RSpec.describe NewgisticsApi::Tracking do
  it "should parse the tracking events of a delivered RETURN package" do
    VCR.use_cassette("tracking/delivered_return") do
      result = subject.track_shipment(merchant_id: "1234", qualifier: "Barcode", search_strings: ["72123456"]).decorated_response

      expect(result[:ngst_status]).to eql("Delivered")
      expect(result[:simple_status]).to eql("delivered")
      expect(result[:relevant_events][:shipped][:timestamp].to_s).to eql(Time.parse("2017-11-14 07:00:00").to_s)
      expect(result[:relevant_events][:delivered][:timestamp].to_s).to eql(Time.parse("2017-11-20 07:00:00").to_s)
    end
  end

  it "should parse the tracking events of a delivered SHIPMENT package" do
    VCR.use_cassette("tracking/delivered_shipment") do
      result = subject.track_shipment(merchant_id: "1234", qualifier: "Barcode", search_strings: ["42123456"]).decorated_response

      expect(result[:ngst_status]).to eql("Delivered")
      expect(result[:simple_status]).to eql("delivered")
      expect(result[:relevant_events][:shipped][:timestamp].to_s).to eql(Time.parse("2017-11-18 07:00:00").to_s)
      expect(result[:relevant_events][:delivered][:timestamp].to_s).to eql(Time.parse("2017-11-22 07:00:00").to_s)
    end
  end
end
