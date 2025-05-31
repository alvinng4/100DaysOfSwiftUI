import SwiftUI

struct ContentView: View
{
    @State private var order = Order()

    var body: some View
    {
        NavigationStack
        {
            Form
            {
                Section
                {
                    Picker("Select your cake type", selection: $order.orderData.type)
                    {
                        ForEach(Order.types.indices, id: \.self)
                        {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper("Number of cakes: \(order.orderData.quantity)", value: $order.orderData.quantity, in: 3...20)
                }

                Section
                {
                    Toggle("Any special requests?", isOn: $order.orderData.specialRequestEnabled)

                    if (order.orderData.specialRequestEnabled)
                    {
                        Toggle("Add extra frosting", isOn: $order.orderData.extraFrosting)

                        Toggle("Add extra sprinkles", isOn: $order.orderData.addSprinkles)
                    }
                }

                Section
                {
                    NavigationLink("Delivery details")
                    {
                        AddressView(order: order)
                    }
                }
            }
                .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview
{
    ContentView()
}
