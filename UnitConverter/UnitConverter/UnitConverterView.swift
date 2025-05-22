import SwiftUI

struct UnitConverterView: View
{
    enum TemperatureUnit: String, CaseIterable, Identifiable
    {
        case Kelvin
        case Celsius
        case Fahrenheit
        var id: Self { self }
    }
    @State private var inputTemp: Double? = nil
    @State private var inputUnit: TemperatureUnit = .Kelvin
    @State private var outputUnit: TemperatureUnit = .Kelvin
    @FocusState private var inputIsFocused: Bool

    private var outputTemp: Double
    {
        if (inputTemp == nil)
        {
            return 0.0
        }

        let inputTempValue: Double = inputTemp!
        var output: Double

        /* Convert input to Kelvin */
        switch (inputUnit)
        {
            case .Kelvin:
                output = inputTempValue
            case .Celsius:
                output = inputTempValue + 273.15
            case .Fahrenheit:
                output = (inputTempValue - 32.0) * 5.0 / 9.0 + 273.15
        }
        
        /* Convert Kelvin to Output Unit */
        switch (outputUnit)
        {
            case .Kelvin:
                return output
            case .Celsius:
                return output - 273.15
            case .Fahrenheit:
                return (output - 273.15) * 9.0 / 5.0 + 32.0
        }
    }

    var body: some View
    {
        NavigationStack
        {
            Form
            {
                Section("Input")
                {
                    TextField(
                        "Value",
                        value: $inputTemp,
                        format: .number,
                    ).keyboardType(.decimalPad)
                        .focused($inputIsFocused)

                    Picker("Unit", selection: $inputUnit)
                    {
                        ForEach(TemperatureUnit.allCases)
                        {
                            unit in
                            Text(unit.rawValue)
                                .tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Output")
                {
                    Text(
                        String(
                            format: "%g",
                            outputTemp
                        )
                    )

                    Picker("Unit", selection: $outputUnit)
                    {
                        ForEach(TemperatureUnit.allCases)
                        {
                            unit in
                            Text(unit.rawValue)
                                .tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }.navigationTitle("UnitConverter")
                .toolbar
                {
                    if (inputIsFocused)
                    {
                        Button("Done")
                        {
                            inputIsFocused = false
                        }
                    }
                }
        }
    }
}

#Preview
{
    UnitConverterView()
}
