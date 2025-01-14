//
//  UnitType.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 9/1/2025.
//


//protocol UnitType {
//    var fullName: String { get }
//    var shortName: String { get }
//    var factor: Double { get }
//}
//
//// Weight
//enum WeightUnit: String, UnitType, CaseIterable {
//    case gram = "g"
//    case kilogram = "kg"
//    case pound = "lb"
//    case ounce = "oz"
//
//    var fullName: String {
//        switch self {
//        case .gram: return "Gram"
//        case .kilogram: return "Kilogram"
//        case .pound: return "Pound"
//        case .ounce: return "Ounce"
//        }
//    }
//
//    var shortName: String { rawValue }
//
//    var factor: Double {
//        switch self {
//        case .gram: return 1.0
//        case .kilogram: return 1000.0
//        case .pound: return 453.592
//        case .ounce: return 28.3495
//        }
//    }
//}
//
//// Height
//enum HeightUnit: String, UnitType, CaseIterable {
//    case millimeter = "mm"
//    case centimeter = "cm"
//    case meter = "m"
//    case kilometer = "km"
//    case inch = "in"
//    case foot = "ft"
//    case mile = "mi"
//
//    var fullName: String {
//        switch self {
//        case .millimeter: return "Millimeter"
//        case .centimeter: return "Centimeter"
//        case .meter: return "Meter"
//        case .kilometer: return "Kilometer"
//        case .inch: return "Inch"
//        case .foot: return "Foot"
//        case .mile: return "Mile"
//        }
//    }
//
//    var shortName: String { rawValue }
//
//    var factor: Double {
//        switch self {
//        case .millimeter: return 1.0
//        case .centimeter: return 10.0
//        case .meter: return 1000.0
//        case .kilometer: return 1_000_000.0
//        case .inch: return 25.4
//        case .foot: return 304.8
//        case .mile: return 1_609_344.0
//        }
//    }
//}
//
//// TemperatureUnit
//enum TemperatureUnit: String, UnitType, CaseIterable {
//    case celsius = "C"
//    case fahrenheit = "F"
//
//    var fullName: String {
//        switch self {
//        case .celsius: return "Celsius"
//        case .fahrenheit: return "Fahrenheit"
//        }
//    }
//
//    var shortName: String { rawValue }
//
//    var factor: Double {
//        // Not applicable for temperature, return 1 as a placeholder
//        return 1.0
//    }
//
//    func convertToBase(value: Double) -> Double {
//        switch self {
//        case .celsius: return value // Base unit is Celsius
//        case .fahrenheit: return (value - 32) * 5 / 9
//        }
//    }
//
//    func convertFromBase(value: Double, to targetUnit: TemperatureUnit) -> Double {
//        switch targetUnit {
//        case .celsius: return value
//        case .fahrenheit: return value * 9 / 5 + 32
//        }
//    }
//}
