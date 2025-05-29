import Foundation
import SwiftUI

struct Record: Codable, Identifiable
{
    var id: UUID = UUID()
    var recordDate: Date
    
    var recordDateString: String
    {
        recordDate.formatted(date: .abbreviated, time: .complete)
    }
}

struct Habit: Codable, Hashable, Identifiable
{
    var id: UUID = UUID()
    var name: String
    var records: [Record] = []
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }

    static func == (lhs: Habit, rhs: Habit) -> Bool
    {
        return lhs.id == rhs.id
    }
}

@Observable
final class HabitTrackerModel
{
    var habits: [Habit] = []
    {
        didSet
        {
            if let encoded = try? JSONEncoder().encode(habits)
            {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
    
    init()
    {
        if let savedItems = UserDefaults.standard.data(forKey: "Habits")
        {
            if let decodedItems = try? JSONDecoder().decode([Habit].self, from: savedItems)
            {
                habits = decodedItems
                return
            }
        }

        habits = []
    }

    func createHabit(name: String)
    {
        habits.append(Habit(name: name))
    }

    func getHabitFromHabitID(_ id: UUID) -> Habit?
    {
        let idx: Int? = habits.firstIndex(where: { $0.id == id })
        if (idx == nil)
        {
            return nil
        }
        else
        {
            return habits[idx!]
        }
    }

    func logHabit(habitID: UUID)
    {
        let idx: Int? = habits.firstIndex(where: { $0.id == habitID })
        if (idx != nil)
        {
            habits[idx!].records.append(Record(recordDate: Date.now))
        }
    }
}
