import SwiftUI

struct HomeView: View
{
    var model: HabitTrackerModel
    @State var showAddHabit = false
    
    var body: some View
    {
        NavigationStack
        {
            Group
            {
                Form
                {
                    Section("Habits")
                    {
                        ForEach(model.habits)
                        { habit in
                            NavigationLink(habit.name, value: habit.id)
                        }
                    }
                }
            }
                .toolbar
                {
                    ToolbarItem
                    {
                        Button("Add New Habit", systemImage: "plus")
                        {
                            showAddHabit = true
                        }
                    }
                }
                .sheet(isPresented: $showAddHabit)
                {
                    addNewHabitView(model: model)
                }
                .navigationTitle("Habit Tracker")
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .navigationDestination(for: UUID.self)
                { habitID in
                   HabitView(model: model, habitID: habitID)
                }
        }
    }
}

struct addNewHabitView: View
{
    @Environment(\.dismiss) var dismiss
    var model: HabitTrackerModel
    @State private var name: String = ""

    var body: some View
    {
        NavigationStack
        {
            Form
            {
                TextField("Habit name", text: $name)
            }
                .navigationTitle("Add new habit")
                .toolbar
                {
                    Button("Save")
                    {
                        model.createHabit(name: name)
                        dismiss()
                    }
                }
        }
    }
}

struct HabitView: View
{
    var model: HabitTrackerModel
    var habitID: UUID
    var habit: Habit?
    {
        return model.getHabitFromHabitID(habitID)
    }

    var body: some View
    {
        Form
        {
            Section("Name")
            {
                if (habit == nil)
                {
                    Text("Error")
                }
                else
                {
                    Text(habit!.name)
                }
            }
            
            Section("Records")
            {
                if (habit == nil)
                {
                    Text("Error")
                }
                else
                {
                    ForEach(habit!.records.reversed())
                    { record in
                        Text(record.recordDateString)
                    }
                }
            }
        }
        
        Spacer()
        
        Button("Log")
        {
            model.logHabit(habitID: habitID)
        }
    }
}

#Preview
{
    var habitTrackerModel = HabitTrackerModel()
    HomeView(model: habitTrackerModel)
}
