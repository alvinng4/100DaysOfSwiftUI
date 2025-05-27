import SwiftUI

struct ExpenseItem: Identifiable, Codable
{
    var id: UUID = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses
{
    var items: [ExpenseItem] = []
    {
        didSet
        {
            if let encoded = try? JSONEncoder().encode(items)
            {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

    init()
    {
        if let savedItems = UserDefaults.standard.data(forKey: "Items")
        {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems)
            {
                items = decodedItems
                return
            }
        }

        items = []
    }
}

struct iExpenseView: View
{
    @State private var expenses = Expenses()

    @State private var showingAddExpense = false

    var body: some View
    {
        NavigationStack
        {
            List
            {
                Section("Personal")
                {
                    ForEach(expenses.items)
                    { item in
                        if (item.type == "Personal")
                        {
                            HStack
                            {
                                Text(item.name)
                                
                                Spacer()
                                
                                Text(item.amount,
                                     format: .currency(
                                        code: Locale.current.currency?.identifier ?? "USD"
                                     )
                                ).foregroundStyle(
                                    getColor(amount: item.amount)
                                )
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section("Business")
                {
                    ForEach(expenses.items)
                    { item in
                        if (item.type == "Business")
                        {
                            HStack
                            {
                                Text(item.name)
                                
                                Spacer()
                                
                                Text(item.amount,
                                     format: .currency(
                                        code: Locale.current.currency?.identifier ?? "USD"
                                     )
                                ).foregroundStyle(
                                    getColor(amount: item.amount)
                                )
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar
            {
                Button("Add Expense", systemImage: "plus")
                {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense)
            {
                AddView(expenses: expenses)
            }
        }
    }

    func removeItems(at offsets: IndexSet)
    {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func getColor(amount: Double) -> Color
    {
        if (amount < 10.0)
        {
            // Green
            return Color(red: 0.0, green: 0.75, blue: 0.0)
        }
        else if (amount < 100.0)
        {
            // Yellow
            return Color(red: 0.9, green: 0.8, blue: 0.0)
        }
        else
        {
            // Red
            return Color(red: 0.9, green: 0.05, blue: 0.05)
        }
    }
}

#Preview
{
    iExpenseView()
}
