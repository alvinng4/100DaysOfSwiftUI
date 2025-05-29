import SwiftUI

@main
struct HabitTrackerApp: App
{
    @State var habitTrackerModel = HabitTrackerModel()
    var body: some Scene
    {
        WindowGroup
        {
            HomeView(model: habitTrackerModel)
        }
    }
}
