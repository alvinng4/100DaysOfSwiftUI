import SwiftUI

struct WeSplitView: View
{
    @State private var checkAmount: Double = 0.0
    @State private var numberOfPeopleMinusTwo: Int = 0 // Default and minimum is 2
    @State private var tipPercentage: Int = 20
    @FocusState private var amountIsFocused: Bool
    
    var numberOfPeople: Int
    {
        return numberOfPeopleMinusTwo + 2
    }
    
    var totalAmount: Double
    {
        return checkAmount * Double(100 + tipPercentage) / 100.0
    }

    var totalPerPerson: Double
    {
        return totalAmount / Double(numberOfPeople)
    }

    var body: some View
    {
        NavigationStack
        {
            Form
            {
                Section
                {
                    TextField(
                        "Amount",
                        value: $checkAmount,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD"
                        )
                    ).keyboardType(.decimalPad)
                        .focused($amountIsFocused)

                    Picker("Number of people", selection: $numberOfPeopleMinusTwo)
                    {
                        ForEach(2..<100)
                        {
                            Text("\($0) people")
                        }
                    }
                }

                Section("Tip percentage")
                {
                    Picker("Tip percentage", selection: $tipPercentage)
                    {
                        ForEach(0..<101, id: \.self)
                        {
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.navigationLink)
                }

                Section("Total Amount")
                {
                    Text(
                        totalAmount,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD"
                        )
                    ).foregroundStyle(tipPercentage == 0 ? .red : .black) // Project 3 Challenge 1
                }

                Section("Amount per person")
                {
                    Text(
                        totalPerPerson,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD"
                        )
                    )
                }
            }.navigationTitle("WeSplit")
                .toolbar
                {
                    if amountIsFocused
                    {
                        Button("Done")
                        {
                            amountIsFocused = false
                        }
                    }
                }
        }
    }
}

#Preview
{
    WeSplitView()
}
