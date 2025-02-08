//
//  CustomKeyboardView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 14/1/2025.
//

import SwiftUI

struct CustomKeyboardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var text: String // Bind the text to update the input field

    var onAC: () -> Void // Closure to handle "Clear" button
    var onNext: () -> Void // Closure to handle "Next" button
    var onDone: () -> Void // Closure to handle "Save" button

    let grid: [[String]] = [
        ["7", "8", "9", "⌫"], // Backspace
        ["4", "5", "6", "Clear"], // Reset
        ["1", "2", "3", "→"], // Done
        ["000", "0", ".", "Save"] // Extra row
    ]
    
    func backgroundColor(key: String) -> Color {
        key == "Save" ? Color(hex: "FFDC23") :
        key == "⌫" || key == "Clear" || key == "→" ? colorScheme == .dark ? Color(.systemFill) : Color(hex: "F0F0F5") :
        Color(.systemBackground)
    }
    
    func foregroundColor(key: String) -> Color {
        key == "Save" ? .black :
        key == "⌫" || key == "Clear" || key == "→" ? colorScheme == .dark ? .white : .black : .primary
    }
    
    func borderColor(key: String) -> Color {
        key == "Save" ? .clear :
        key == "⌫" || key == "Clear" || key == "→" ? colorScheme == .dark ? Color(.systemFill) : Color(.systemGray5) :
        colorScheme == .dark ? Color(.systemGray5) : .clear
    }

    var body: some View {
        VStack(spacing: 10) {
            ForEach(grid, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            handleKeyPress(key)
                        }) {
                            Text(key)
                                .font(key == "⌫" ? .title : .title2)
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .background(backgroundColor(key: key))
                                .foregroundColor(foregroundColor(key: key))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(borderColor(key: key), lineWidth: 2)
                                )
                        }
                        .disabled(key.isEmpty) // Disable empty buttons
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 12)
        .padding(.top, 7)
        .background(Color(.systemGray6))
    }

    private func handleKeyPress(_ key: String) {
        switch key {
        case "⌫":
            if !text.isEmpty {
                text.removeLast()
            }
        case "Clear":
            text = ""
            onAC()
        case "Save":
            onDone()
        case "→":
            onNext()
        case "000":
            text += "000"
        case ".":
            if !text.contains(".") {
                text += "."
            }
        default:
            text += key
        }
    }
}


#Preview {
    CustomKeyboardView(text: .constant("0"), onAC: {
        //
    }, onNext: {
        //
    }, onDone: {
        //
    })
}
