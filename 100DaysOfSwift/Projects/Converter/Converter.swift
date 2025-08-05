//
//  Conversions.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 1/7/25.
//

import SwiftUI

struct Converter: View {
    private let units = TemperatureUnit.allCases
    
    @State private var fromUnit: TemperatureUnit = .celsius
    @State private var toUnit: TemperatureUnit = .celsius
    @State private var value = 0.0
    
    private var convertedValue: Double {
        convert(value, from: fromUnit, to: toUnit)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Select Units") {
                    Picker("From Unit", selection: $fromUnit) {
                        ForEach(units, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    Picker("To Unit", selection: $toUnit) {
                        ForEach(units, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                Section("Enter Value") {
                    TextField("Value", value: $value, format: .number.precision(.fractionLength(2)))
                        .keyboardType(.decimalPad)
                }
                
                Section("Converted Value") {
                    Text("\(convertedValue, format: .number.precision(.fractionLength(2)))°C")
                }
            }
        }
        .navigationTitle("Converter")
    }
}

extension Converter {
    enum TemperatureUnit: String, CaseIterable, Identifiable {
        case celsius = "Celsius"
        case fahrenheight = "Fahrenheit"
        case kelvin = "Kelvin"
        
        var id: String { rawValue }
    }
}

extension Converter {
    private func convert(_ value: Double, from: TemperatureUnit, to: TemperatureUnit) -> Double {
        guard from != to else {
            return value
        }
        
        let celsiusValue: Double
        switch from {
            case .celsius: celsiusValue = value
            case .fahrenheight: celsiusValue = (value - 32) * 5 / 9
            case .kelvin: celsiusValue = value - 273.15
        }
        
        switch to {
            case .celsius: return celsiusValue
            case .fahrenheight: return (celsiusValue * 9 / 5) + 32
            case .kelvin: return celsiusValue + 273.15
        }
    }
}

#Preview {
    Converter()
}
