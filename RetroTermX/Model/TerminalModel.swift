//
//  TerminalModel.swift
//  RetroTermX
//
//  Created by Aidin Ahmadian on 7/14/24.
//

import Foundation
import UIKit

struct TerminalModel {
    private(set) var initialText: String
    private(set) var availableCommands: String
    private(set) var commandHistory: [String] = []

    init() {
        self.initialText = """
        Welcome to the Vintage Terminal!

        User@Machine:~$ echo 'Hello, World!'
        Hello, World!
        """
        self.availableCommands = """
        \n\nAvailable commands:
        - help: Display this help message
        - clear: Clear the terminal screen
        - echo [text]: Echo the text back to the terminal
        - date: Show the current date and time
        - list: List sample items
        - math [expression]: Evaluate a simple math expression (e.g., math 2+2)
        - history: Show command history
        - random: Display a random number
        """
    }

    mutating func addCommandToHistory(_ command: String) {
        commandHistory.append(command)
    }

    func processCommand(_ command: String) -> String {
        let components = command.split(separator: " ", maxSplits: 1)
        let mainCommand = components.first?.lowercased() ?? ""
        let argument = components.count > 1 ? String(components[1]) : ""

        switch mainCommand {
        case "help":
            return availableCommands
        case "clear":
            return ""
        case "echo":
            return argument
        case "date":
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .long
            return dateFormatter.string(from: Date())
        case "list":
            return """
            - Item 1
            - Item 2
            - Item 3
            """
        case "math":
            return evaluateMathExpression(argument)
        case "history":
            return commandHistory.joined(separator: "\n")
        case "random":
            return String(Int.random(in: 1...1000))
        default:
            return "Command not found: \(command)"
        }
    }

    private func evaluateMathExpression(_ expression: String) -> String {
        let sanitizedExpression = expression.replacingOccurrences(of: "[^0-9+\\-*/().]", with: "", options: .regularExpression)
        if sanitizedExpression.isEmpty {
            return "Invalid expression"
        }

        let exp: NSExpression = NSExpression(format: sanitizedExpression)
        if let result = exp.expressionValue(with: nil, context: nil) as? NSNumber {
            return "\(result)"
        } else {
            return "Invalid expression"
        }
    }
}
