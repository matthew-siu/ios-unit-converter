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

    var onDone: () -> Void // Closure to handle "Done" button

    let grid: [[String]] = [
        ["7", "8", "9", "⌫"], // Backspace
        ["4", "5", "6", "AC"], // Reset
        ["1", "2", "3", ""], // Done
        ["000", "0", ".", "Done"] // Extra row
    ]
    
    func backgroundColor(key: String) -> Color {
        key == "Done" ? Color(hex: "FFDC23") :
        key == "⌫" || key == "AC" ? colorScheme == .dark ? Color(.systemFill) : Color(hex: "F0F0F5") :
        Color(.systemBackground)
    }
    
    func foregroundColor(key: String) -> Color {
        key == "Done" ? .black :
        key == "⌫" || key == "AC" ? colorScheme == .dark ? .white : .black : .primary
    }
    
    func borderColor(key: String) -> Color {
        key == "Done" ? .clear :
        key == "⌫" || key == "AC" ? colorScheme == .dark ? Color(.systemFill) : Color(.systemGray5) :
        colorScheme == .dark ? Color(.systemGray5) : .clear
    }

    var body: some View {
        VStack(spacing: 12) {
            ForEach(grid, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            handleKeyPress(key)
                        }) {
                            Text(key)
                                .font(.title2)
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: 60)
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
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private func handleKeyPress(_ key: String) {
        switch key {
        case "⌫":
            if !text.isEmpty {
                text.removeLast()
            }
        case "AC":
            text = ""
        case "Done":
            onDone()
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
    CustomKeyboardView(text: .constant("0")) {
        print("Done!")
    }
}
