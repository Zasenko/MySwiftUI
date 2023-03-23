//
//  ValidationType.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 23.03.23.
//

import Foundation

enum Field: String {
    case username
    case password
}

enum ValidationState {
    case success
    case failure
}

enum ValidationType {
    case isNotEmpty
    case minCharacters(min: Int)
    case hasSymbols
    case hasUppercasedLetters
    
    func fulfills(string: String) -> Bool {
        switch self {
        case .isNotEmpty:
            return !string.isEmpty
        case .minCharacters(min: let min):
            return string.count > min
        case .hasSymbols:
            return string.hasSpecialCharacters()
        case .hasUppercasedLetters:
            return string.hasUppercasedCharacters()
        }
    }
    
    func message(fieldName: String) -> String {
        switch self {
        case .isNotEmpty:
            return "\(fieldName) must not be empty"
        case .minCharacters(min: let min):
            return "\(fieldName) must be longer than \(min) characters"
        case .hasSymbols:
            return "\(fieldName) must have a symbol"
        case .hasUppercasedLetters:
            return "\(fieldName) must have an uppercase letter"
        }
    }
}


extension String {
    func hasUppercasedCharacters() -> Bool {
        return stringFulfillsRegex(regex:  ".*[A-Z]+.*")
    }
    func hasSpecialCharacters() -> Bool {
        return stringFulfillsRegex(regex: ".*[^A-Za-z0-9].*")
    }
    private func stringFulfillsRegex(regex: String) -> Bool {
        let texttest = NSPredicate(format: "SELF MATCHES %@", regex)
        guard texttest.evaluate(with: self) else {
            return false
        }
        return true
    }
}

struct Validation: Identifiable {
    var id: Int
    var field: Field
    var validationType: ValidationType
    var state: ValidationState
    
    init(string: String, id: Int, field: Field, validationType: ValidationType) {
        self.id = id
        self.field = field
        self.validationType = validationType
        self.state = validationType.fulfills(string: string) ? .success : .failure
    }
}
