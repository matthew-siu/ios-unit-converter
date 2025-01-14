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
    var defaultDollarSign: Bool { get }
    var deeplinkPath: String { get }
    var units: [UnitType] { get }
    func convert(value: Double, from: UnitType, to: UnitType) -> Double
    
}

class Eggs: MeasurementType{
    typealias UnitType = UnitDozan
    let id = UUID()
    let name = "Egg"
    let icon = "icon_egg"
    let defaultDollarSign = true
    let deeplinkPath = "converter/eggs"
    let units: [UnitDozan] = [.halfDozan, .dozan, .onehalfDozan, .twoDozan, .twoHalfDozan]
    
    func convert(value: Double, from: UnitDozan, to: UnitDozan) -> Double {
//        let inputMeasurement = Measurement(value: value, unit: from)
//        return inputMeasurement.converted(to: to).value
        let unitToBaseCoefficient = 1 / from.converter.value(fromBaseUnitValue: 1)
        print("convert: \(value) / \(unitToBaseCoefficient)")
        return value / unitToBaseCoefficient
    }
}

class UnitDozan: Dimension {
    static let halfDozan = UnitDozan(symbol: "6", converter: UnitConverterLinear(coefficient: 6))
    static let dozan = UnitDozan(symbol: "12 (dozan)", converter: UnitConverterLinear(coefficient: 12))
    static let onehalfDozan = UnitDozan(symbol: "18", converter: UnitConverterLinear(coefficient: 18))
    static let twoDozan = UnitDozan(symbol: "24", converter: UnitConverterLinear(coefficient: 24))
    static let twoHalfDozan = UnitDozan(symbol: "30", converter: UnitConverterLinear(coefficient: 30))

    override class func baseUnit() -> Self {
        return UnitDozan(symbol: "egg", converter: UnitConverterLinear(coefficient: 1)) as! Self
    }
}

class Length: MeasurementType {
    typealias UnitType = UnitLength
    let id = UUID()
    let name = "Length"
    let icon = "icon_length"
    let defaultDollarSign = false
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
    let defaultDollarSign = false
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
    let defaultDollarSign = false
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
    let defaultDollarSign = false
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
    let defaultDollarSign = false
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
    let defaultDollarSign = false
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
