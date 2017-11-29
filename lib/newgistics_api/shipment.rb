module NewgisticsApi
  class Shipment < Client
    def create_shipment(additional_data: nil, consumer: nil, client_service_flag: nil, disposition_rule_set_id: nil, label_count: nil, merchant_id: nil, return_id: nil, show_zpl_link: false)
      make_request(:post, "/WebAPI/Shipment/") do
        {
          "additionalData" => additional_data.map do |name, value|
            { "Name" => name, "Value" => value }
          end,
          "clientServiceFlag" => client_service_flag,
          "consumer" => {
            "Address" => {
              "Address1" => consumer["Address"]["Address1"],
              "Address2" => consumer["Address"]["Address2"],
              "Address3" => consumer["Address"]["Address3"],
              "City" => consumer["Address"]["City"],
              "CountryCode" => consumer["Address"]["CountryCode"],
              "Name" => consumer["Address"]["Name"],
              "State" => consumer["Address"]["State"],
              "Zip" => consumer["Address"]["Zip"],
            },
            "DaytimePhoneNumber" => consumer["Address"]["DaytimePhoneNumber"],
            "EveningPhoneNumber" => consumer["Address"]["EveningPhoneNumber"],
            "FaxNumber" => consumer["Address"]["FaxNumber"],
            "FirstName" => consumer["FirstName"],
            "Honorific" => consumer["Honorific"],
            "LastName" => consumer["LastName"],
            "MiddleInitial" => consumer["MiddleInitial"],
            "PrimaryEmailAddress" => consumer["PrimaryEmailAddress"],
          },
          "deliveryMethod" => "SelfService",
          "dispositionRuleSetId" => disposition_rule_set_id,
          "labelCount" => label_count,
          "merchantID" => merchant_id,
          "returnId" => return_id,
          "showZplLink" => show_zpl_link
        }
      end
    end
  end
end
