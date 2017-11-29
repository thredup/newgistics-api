module NewgisticsApi
  class Tracking < Client
    SERVICE_TYPES = [
      SERVICE_SHIPMENT = "SHIPMENT", # Outbound
      SERVICE_RETURN = "RETURN" # Inbound
    ]

    # Shipment codes
    SHIPMENT_SHIPPED_CODES = %w(PSC IPS)
    SHIPMENT_DELIVERED_CODES = %w(DEL)

    # Return codes
    RETURN_SHIPPED_CODES = %w(PUU UPROC)
    RETURN_DELIVERED_CODES = %w(DRC)

    SHIPPED_CODES = SHIPMENT_SHIPPED_CODES | RETURN_SHIPPED_CODES
    DELIVERED_CODES = SHIPMENT_DELIVERED_CODES | RETURN_DELIVERED_CODES

    STATUSES = [
      STATUS_CREATED = "Created",
      STATUS_DELIVERED = "Delivered",
      STATUS_DEPARTED = "Departed",
      STATUS_EXCEPTION = "Exception",
      STATUS_IN_TRANSIT = "InTransit",
      STATUS_IN_USPS_NETWORK = "InUSPSNetwork",
      STATUS_NOT_FOUND = "NotFound",
      STATUS_RECEIVED = "Received",
      STATUS_UNKNOWN = "Unknown"
    ]

    def track_shipment(merchant_id: nil, qualifier: nil, search_strings: [])
      make_request(:post, "/WebAPI/Shipment/Tracking") do
        {
          "merchantID" => merchant_id,
          "qualifier" => qualifier,
          "searchStrings" => search_strings
        }
      end
    end

    class Decorator
      def self.decorate(response)
        return {} if (package = (response["Packages"] || [])[0]).nil?
        return {} if (events = package["PackageTrackingEvents"] || []).empty?

        raise NewgisticsApi::NotFoundTrackingNumberError.new if response["Status"] == STATUS_NOT_FOUND

        # Outbound - packages shipped from the DC
        # Inbound - packages handed by the customer to the carrier
        shipped_event = events.find { |event| event && SHIPPED_CODES.include?(event["EventCode"]) }
        delivered_event = events.find { |event| event && DELIVERED_CODES.include?(event["EventCode"]) }

        {
          ngst_status: package["Status"],
          simple_status: determine_simple_status(
            package,
            shipped_event,
            delivered_event
          ),
          all_events: events,
          relevant_events: {
            shipped: shipped_event ? { timestamp: parse_event_date(shipped_event), details: shipped_event } : nil,
            delivered: delivered_event ? { timestamp: parse_event_date(delivered_event), details: delivered_event } : nil
          }
        }
      end

      private

      # What interests us is either the package is in states:
      # - shipped (shipments)
      # - delivered (shipments and returns)
      # - inbound (returns)
      def self.determine_simple_status(package, shipped_event, delivered_event)
        status = package["Status"]
        service = package["Service"]

        return "delivered" if delivered_event
        if shipped_event
          return "inbound" if service == SERVICE_RETURN
          return "shipped"
        end
        return status if status == STATUS_UNKNOWN
        return "created" if status == STATUS_CREATED
      end

      def self.parse_event_date(event)
        return unless event
        return if (date = event["Date"]).match(%r(^\/Date\((.*)-)).nil?
        time = date.match(%r(^\/Date\((.*)-))[1]
        Time.at(time.to_i / 1000)
      end
    end
  end
end
