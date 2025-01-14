//
//  MeasureType.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 9/1/2025.
//

import Foundation

protocol MeasurementType {
    associatedtype UnitType: Dimension
    var id: UUID { get }
    var name: String { get }
    var icon: String { get }
    var deeplinkPath: String { get }
    var units: [UnitType] { get }
    func convert(value: Double, from: UnitType, to: UnitType) -> Double
    
}

class Length: MeasurementType {
    typealias UnitType = UnitLength
    let id = UUID()
    let name = "Length"
    let icon = "icon_length"
    let deeplinkPath = "converter/length"
    let units: [UnitLength] = [.millimeters, .centimeters, .meters, .kilometers, .inches, .feet, .miles]

    func convert(value: Double, from: UnitLength, to: UnitLength) -> Double {
        let inputMeasurement = Measurement(value: value, unit: from)
        return inputMeasurement.converted(to: to).value
    }
}

class Weight: MeasurementType {
    typealias UnitType = UnitMass
    let id = UUID()
    let name = "Weight"
    let icon = "icon_weight"
    let deeplinkPath = "converter/weight"
    let units: [UnitMass] = [.grams, .kilograms, .milligrams, .pounds, .ounces, .metricTons]

    func convert(value: Double, from: UnitMass, to: UnitMass) -> Double {
        let inputMeasurement = Measurement(value: value, unit: from)
        return inputMeasurement.converted(to: to).value
    }
}

class Volume: MeasurementType {
    typealias UnitType = UnitVolume
    let id = UUID()
    let name = "Volume"
    let icon = "icon_volume"
    let deeplinkPath = "converter/volume"
    let units: [UnitVolume] = [.liters, .milliliters, .cubicMeters, .cubicCentimeters, .gallons, .quarts, .cubicInches, .cubicFeet]

    func convert(value: Double, from: UnitVolume, to: UnitVolume) -> Double {
        let inputMeasurement = Measurement(value: value, unit: from)
        return inputMeasurement.converted(to: to).value
    }
}

class Temperature: MeasurementType {
    typealias UnitType = UnitTemperature
    let id = UUID()
    let name = "Temperature"
    let icon = "icon_temperature"
    let deeplinkPath = "converter/temperature"
    let units: [UnitTemperature] = [.celsius, .fahrenheit]

    func convert(value: Double, from: UnitTemperature, to: UnitTemperature) -> Double {
        let inputMeasurement = Measurement(value: value, unit: from)
        return inputMeasurement.converted(to: to).value
    }
}

class Area: MeasurementType {
    typealias UnitType = UnitArea
    let id = UUID()
    let name = "Area"
    let icon = "icon_area"
    let deeplinkPath = "converter/area"
    let units: [UnitArea] = [.squareInches, .squareFeet, .squareMeters, .squareKilometers, .squareMiles]

    func convert(value: Double, from: UnitArea, to: UnitArea) -> Double {
        let inputMeasurement = Measurement(value: value, unit: from)
        return inputMeasurement.converted(to: to).value
    }
}

class CookingMeasurement: MeasurementType {
    typealias UnitType = Dimension
    let id = UUID()
    let name = "Cooking Measurements"
    let icon = "icon_cooking"
    let deeplinkPath = "converter/cooking"
    let units: [UnitType] = [UnitConverter.custom(unitName: "Cup", multiplier: 240.0),
                             UnitConverter.custom(unitName: "Tablespoon", multiplier: 15.0),
                             UnitConverter.custom(unitName: "Teaspoon", multiplier: 5.0)]

    func convert(value: Double, from: Dimension, to: Dimension) -> Double {
        guard let fromConverter = from.converter as? UnitConverterCustom,
              let toConverter = to.converter as? UnitConverterCustom else { return value }
        return value * (fromConverter.multiplier / toConverter.multiplier)
    }
}

extension UnitConverter {
    static func custom(unitName: String, multiplier: Double) -> Dimension {
        return Dimension(symbol: unitName, converter: UnitConverterCustom(multiplier: multiplier))
    }
}

class UnitConverterCustom: UnitConverter {
    let multiplier: Double
    init(multiplier: Double) {
        self.multiplier = multiplier
        super.init()
    }
    override func baseUnitValue(fromValue value: Double) -> Double {
        return value * multiplier
    }
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        return baseUnitValue / multiplier
    }
}
