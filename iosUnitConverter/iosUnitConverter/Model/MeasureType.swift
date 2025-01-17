//
//  MeasureType.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 9/1/2025.
//

import Foundation

class MeasurementType {
    let id: UUID
    let name: String
    let icon: String
    let defaultDollarSign: Bool
    let deeplinkPath: String
    let units: [Dimension]
    
    var defaultInput: Dimension{
        return units[0]
    }
    
    var defaultOutput: Dimension{
        return units[1]
    }
    
    init(id: UUID = UUID(),
         name: String,
         icon: String,
         defaultDollarSign: Bool,
         deeplinkPath: String,
         units: [Dimension]) {
        self.id = id
        self.name = name
        self.icon = icon
        self.defaultDollarSign = defaultDollarSign
        self.deeplinkPath = deeplinkPath
        self.units = units
    }
    
    func convert(value: Double, from: Dimension, to: Dimension) -> Double {
        let inputMeasurement = Measurement(value: value, unit: from)
        return inputMeasurement.converted(to: to).value
    }
    
    func convert(value: Double, inputPer: Double, outputPer: Double, from: Dimension, to: Dimension) -> Double {
        // Convert the `inputPer` amount to the target unit
        let inputPerInTargetUnit = Measurement(value: inputPer, unit: from).converted(to: to).value
        
        // Calculate the value per target unit
        let valuePerTargetUnit = value / inputPerInTargetUnit
        
        // Scale the value per target unit to the desired `outputPer`
        let scaledValue = valuePerTargetUnit * outputPer
        
        return scaledValue
    }
}

class Eggs: MeasurementType {
    
    init() {
        super.init(
            name: "Egg",
            icon: "oval.portrait",
            defaultDollarSign: true,
            deeplinkPath: "converter?type=eggs",
            units: [
                UnitDozan.one,
                UnitDozan.halfDozan,
                UnitDozan.dozan,
                UnitDozan.onehalfDozan,
                UnitDozan.twoDozan,
                UnitDozan.twoHalfDozan
            ]
        )
    }
    
    override var defaultInput: Dimension{
        return UnitDozan.dozan
    }
    
    override var defaultOutput: Dimension{
        return UnitDozan.onehalfDozan
    }
    
    override func convert(value: Double, from: Dimension, to: Dimension) -> Double {
//        let unitToBaseCoefficient = 1 / from.converter.value(fromBaseUnitValue: to.)
//        return value / unitToBaseCoefficient
        let fromCoefficient = from.converter.baseUnitValue(fromValue: 1)
        let toCoefficient = to.converter.baseUnitValue(fromValue: 1)
            
        return (value / fromCoefficient) * toCoefficient
    }
    
    override func convert(value: Double, inputPer: Double, outputPer: Double, from: Dimension, to: Dimension) -> Double {
        self.convert(value: value, from: from, to: to)
    }
}

class Length: MeasurementType {
    init() {
        super.init(
            name: "Length",
            icon: "arrow.left.and.right",
            defaultDollarSign: false,
            deeplinkPath: "pugskyiuc://converter?type=length",
            units: [
                UnitLength.millimeters,
                UnitLength.centimeters,
                UnitLength.meters,
                UnitLength.kilometers,
                UnitLength.inches,
                UnitLength.feet,
                UnitLength.yards,
                UnitLength.miles
            ]
        )
    }
}

class Weight: MeasurementType {
    override var defaultInput: Dimension{
        return UnitMass.kilograms
    }
    
    override var defaultOutput: Dimension{
        return UnitMass.pounds
    }
    
    init() {
        super.init(
            name: "Weight",
            icon: "escape",
            defaultDollarSign: false,
            deeplinkPath: "pugskyiuc://converter?type=weight",
            units: [
                UnitMass.grams,
                UnitMass.kilograms,
                UnitMass.milligrams,
                UnitMass.pounds,
                UnitMass.ounces,
                UnitMass.metricTons,
                UnitMass.stones
            ]
        )
    }
}

class Volume: MeasurementType {
    init() {
        super.init(
            name: "Volume",
            icon: "cube",
            defaultDollarSign: false,
            deeplinkPath: "pugskyiuc://converter?type=volume",
            units: [
                UnitVolume.liters,
                UnitVolume.milliliters,
                UnitVolume.cubicMeters,
                UnitVolume.cubicCentimeters,
                UnitVolume.gallons,
                UnitVolume.quarts,
                UnitVolume.pints,
                UnitVolume.cups,
                UnitVolume.fluidOunces
            ]
        )
    }
}

class Temperature: MeasurementType {
    init() {
        super.init(
            name: "Temperature",
            icon: "thermometer.medium",
            defaultDollarSign: false,
            deeplinkPath: "pugskyiuc://converter?type=temperature",
            units: [
                UnitTemperature.celsius,
                UnitTemperature.fahrenheit,
                UnitTemperature.kelvin
            ]
        )
    }
}

class Area: MeasurementType {
    init() {
        super.init(
            name: "Area",
            icon: "house",
            defaultDollarSign: false,
            deeplinkPath: "pugskyiuc://converter?type=area",
            units: [
                UnitArea.squareMillimeters,
                UnitArea.squareCentimeters,
                UnitArea.squareMeters,
                UnitArea.squareKilometers,
                UnitArea.squareInches,
                UnitArea.squareFeet,
                UnitArea.squareYards,
                UnitArea.squareMiles,
                UnitArea.acres,
                UnitArea.hectares
            ]
        )
    }
}


// ---------------------------- Custom


class UnitDozan: Dimension {
    static let one = UnitDozan(symbol: "1 egg", converter: UnitConverterLinear(coefficient: 1))
    static let halfDozan = UnitDozan(symbol: "6 eggs", converter: UnitConverterLinear(coefficient: 6))
    static let dozan = UnitDozan(symbol: "12 eggs", converter: UnitConverterLinear(coefficient: 12))
    static let onehalfDozan = UnitDozan(symbol: "18 eggs", converter: UnitConverterLinear(coefficient: 18))
    static let twoDozan = UnitDozan(symbol: "24 eggs", converter: UnitConverterLinear(coefficient: 24))
    static let twoHalfDozan = UnitDozan(symbol: "30 eggs", converter: UnitConverterLinear(coefficient: 30))

    override class func baseUnit() -> Self {
        return UnitDozan(symbol: "egg", converter: UnitConverterLinear(coefficient: 1)) as! Self
    }
    
    static let customLongUnitNames: [UnitDozan: String] = [
        UnitDozan.one: "one unit",
        UnitDozan.halfDozan: "half dozen",
        UnitDozan.dozan: "one dozen",
        UnitDozan.onehalfDozan: "one and a half dozen",
        UnitDozan.twoDozan: "two dozen",
        UnitDozan.twoHalfDozan: "two and a half dozen"
    ]
}

extension Dimension{
    func toFullUnit() -> String{
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.minimumFractionDigits = 1
        if let unit = self as? UnitDozan{
            return UnitDozan.customLongUnitNames[unit] ?? formatter.string(from: self)
        }else{
            return formatter.string(from: self)
        }
    }
}
