//
//  LoginWithCheckCombineViewModel.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 23.03.23.
//

import SwiftUI
import Combine

class LoginWithCheckCombineViewModel: ObservableObject {

    @Published var password = ""
    @Published var validations: [Validation] = []
    @Published var isValid: Bool = false

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        // Validations
        passwordPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validations, on: self)
            .store(in: &cancellableSet)

        // isValid
        passwordPublisher
            .receive(on: RunLoop.main)
            .map { validations in
                return validations.filter { validation in
                    return ValidationState.failure == validation.state
                }.isEmpty
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }

    private var passwordPublisher: AnyPublisher<[Validation], Never> {
        $password
            .removeDuplicates()
            .map { password in

                var validations: [Validation] = []
                validations.append(Validation(string: password,
                                              id: 0,
                                              field: .password,
                                              validationType: .isNotEmpty))

                validations.append(Validation(string: password,
                                              id: 1,
                                              field: .password,
                                              validationType: .minCharacters(min: 8)))

                validations.append(Validation(string: password,
                                              id: 2,
                                              field: .password,
                                              validationType: .hasSymbols))

                validations.append(Validation(string: password,
                                              id: 3,
                                              field: .password,
                                              validationType: .hasUppercasedLetters))
                return validations
            }
            .eraseToAnyPublisher()
    }
}
