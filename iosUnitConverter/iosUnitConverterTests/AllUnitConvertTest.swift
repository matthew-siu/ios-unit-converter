//
//  AllUnitConvertTest.swift
//  iosUnitConverterTests
//
//  Created by Matthew Siu on 13/1/2025.
//

import Testing
@testable import iosUnitConverter

struct AllUnitConvertTest {
    
    @Test func testLengthConversion() async throws {
        let length = Length()
        #expect(length.convert(value: 1000, from: .millimeters, to: .meters) == 1.0)
        #expect(length.convert(value: 1,
                               from: .kilometers, to: .meters) == 1000.0)
        #expect(length.convert(value: 12, from: .inches, to: .feet) == 1.0)
    }
    
    @Test func testWeightConversion() async throws {
        let weight = Weight()
        #expect(weight.convert(value: 1000, from: .grams, to: .kilograms) == 1.0)
        #expect(weight.convert(value: 1, from: .kilograms, to: .grams) == 1000.0)
        #expect(weight.convert(value: 16, from: .ounces, to: .pounds) == 1.0)
    }
    
    @Test func testVolumeConversion() async throws {
        let volume = Volume()
        #expect(volume.convert(value: 1, from: .liters, to: .milliliters) == 1000.0)
        #expect(volume.convert(value: 1, from: .gallons, to: .quarts) == 4.0)
        #expect(volume.convert(value: 1, from: .cubicMeters, to: .liters) == 1000.0)
    }
    
    @Test func testTemperatureConversion() async throws {
        let temperature = Temperature()
        #expect(temperature.convert(value: 0, from: .celsius, to: .fahrenheit) == 32.0)
        #expect(temperature.convert(value: 100, from: .celsius, to: .fahrenheit) == 212.0)
        #expect(temperature.convert(value: 32, from: .fahrenheit, to: .celsius) == 0.0)
    }
    
    @Test func testAreaConversion() async throws {
        let area = Area()
        #expect(area.convert(value: 144, from: .squareInches, to: .squareFeet) == 1.0)
        #expect(area.convert(value: 1, from: .squareMeters, to: .squareKilometers) == 0.000001)
        #expect(area.convert(value: 1, from: .squareMiles, to: .squareKilometers) == 2.58999)
    }
}
