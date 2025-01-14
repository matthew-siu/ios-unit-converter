//
//  CustomKeyboardView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 14/1/2025.
//

import SwiftUI

struct CustomKeyboardView: View {
    @Binding var text: String // Bind the text to update the input field

    var onDone: () -> Void // Closure to handle "Done" button

    let grid: [[String]] = [
        ["7", "8", "9", "⌫"], // Backspace
        ["4", "5", "6", "AC"], // Reset
        ["1", "2", "3", ""], // Done
        ["000", "0", ".", "Done"] // Extra row
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(grid, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            handleKeyPress(key)
                        }) {
                            Text(key)
                                .font(.title)
                                .frame(maxWidth: .infinity, maxHeight: 60)
                                .background(key == "⌫" || key == "AC" || key == "Done" ? Color.blue : Color(hex: "FCFCFE"))
                                .foregroundColor(key == "⌫" || key == "AC" || key == "Done" ? .white : .black)
                                .cornerRadius(8)
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
