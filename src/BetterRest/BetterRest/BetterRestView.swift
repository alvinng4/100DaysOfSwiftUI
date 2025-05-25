import CoreML
import SwiftUI

struct BetterRestView: View
{
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount: Double = 8.0
    @State private var coffeeAmountMinusOne: Int = 1
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false

    static var defaultWakeTime: Date
    {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var recommendedSleepTime: String
    {
        get
        {
            do
            {
                let config = MLModelConfiguration()
                let model = try SleepCalculator(configuration: config)
                
                let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
                let hour = (components.hour ?? 0) * 60 * 60
                let minute = (components.minute ?? 0) * 60
                
                let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
                
                let sleepTime = wakeUp - prediction.actualSleep
                return sleepTime.formatted(date: .omitted, time: .shortened)
            }
            catch
            {
                alertTitle = "Error"
                alertMessage = "Sorry, there was a problem calculating your bedtime."
                showingAlert = true
                return ""
            }
        }
    }
    
    var coffeeAmount: Int
    {
        return coffeeAmountMinusOne + 1
    }

    var body: some View
    {
        NavigationStack
        {
            Form
            {
                Section("When do you want to wake up?")
                {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }

                Section("Desired amount of sleep")
                {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }

                Section("Daily coffee intake")
                {
                    Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmountMinusOne)
                    {
                        ForEach(1..<21)
                        {
                            value in
                            Text("\(value)")
                        }
                    }
                }
                
                Section("Recommended sleep time")
                {
                    Text(recommendedSleepTime)
                        .font(.largeTitle)
                }
            }
            .navigationTitle("BetterRest")
            .alert(alertTitle, isPresented: $showingAlert)
            {
                Button("OK") { }
            }
            message:
            {
                Text(alertMessage)
            }
        }
    }
}

#Preview
{
    BetterRestView()
}
