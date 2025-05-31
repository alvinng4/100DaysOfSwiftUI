import SwiftUI

struct AddressView: View
{
    @Bindable var order: Order

    var body: some View
    {
        Form
        {
            Section
            {
                TextField("Name", text: $order.orderData.name)
                TextField("Street Address", text: $order.orderData.streetAddress)
                TextField("City", text: $order.orderData.city)
                TextField("Zip", text: $order.orderData.zip)
            }

            Section
            {
                NavigationLink("Check out")
                {
                    CheckoutView(order: order)
                }
            }
            .disabled(!order.hasValidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview
{
    AddressView(order: Order())
}
