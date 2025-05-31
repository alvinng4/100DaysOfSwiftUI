import Foundation
import SwiftUI


struct OrderData: Codable
{
    var type: Int = 0
    var quantity: Int = 3
    var specialRequestEnabled: Bool = false
    {
        didSet
        {
            if (specialRequestEnabled == false)
            {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting: Bool = false
    var addSprinkles: Bool = false
    var name: String = ""
    var streetAddress: String = ""
    var city: String = ""
    var zip: String = ""
}

@Observable
final class Order
{
    init()
    {
        if let savedData = UserDefaults.standard.data(forKey: "order")
        {
            if let decodedData = try? JSONDecoder().decode(OrderData.self, from: savedData)
            {
                orderData = decodedData
                return
            }
        }

        orderData = OrderData()
    }

    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var orderData: OrderData = OrderData()
    {
        didSet
        {
            if let encoded = try? JSONEncoder().encode(orderData)
            {
                UserDefaults.standard.set(encoded, forKey: "order")
            }
        }
    }

    var hasValidAddress: Bool
    {
        // Check if any name is empty or contains only white spaces
        return !(
            orderData.name.isEmptyOrWhitespace
            || orderData.streetAddress.isEmptyOrWhitespace
            || orderData.city.isEmptyOrWhitespace
            || orderData.zip.isEmptyOrWhitespace
        )
    }

    var cost: Decimal
    {
        // $2 per cake
        var cost = Decimal(orderData.quantity) * 2

        // complicated cakes cost more
        cost += Decimal(orderData.type) / 2

        // $1/cake for extra frosting
        if (orderData.extraFrosting)
        {
            cost += Decimal(orderData.quantity)
        }

        // $0.50/cake for sprinkles
        if (orderData.addSprinkles)
        {
            cost += Decimal(orderData.quantity) / 2
        }

        return cost
    }
}

extension String
{
    var isEmptyOrWhitespace: Bool
    {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
