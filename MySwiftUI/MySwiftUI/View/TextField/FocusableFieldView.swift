//
//  FocusableFieldView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 29.06.23.
//

import SwiftUI

struct FocusableFieldView: View {
    enum FocusableField: Hashable {
            case firstName, lastName, email
        }

        @State private var firstName: String = ""
        @State private var lastName: String = ""
        @State private var email: String = ""

        @FocusState private var focusedField: FocusableField?

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("First Name", text: $firstName)
                        .focused($focusedField, equals: .firstName)
                    
                    TextField("Last Name", text: $lastName)
                        .focused($focusedField, equals: .lastName)
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .focused($focusedField, equals: .email)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                focusedField = .firstName
            }
            .onTapGesture {
                focusedField = nil
            }
            .onSubmit(focusNextField)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: save)
                }
            }
        }
    }
    
    private func focusNextField() {
            switch focusedField {
            case .firstName:
                focusedField = .lastName
            case .lastName:
                focusedField = .email
            case .email:
                
                focusedField = nil
            case .none:
                break
            }
        }
    
    private func save() {
            if firstName.isEmpty {
                focusedField = .firstName
            } else if lastName.isEmpty {
                focusedField = .lastName
            } else if email.isEmpty {
                focusedField = .email
            } else {
                // Save...
            }
        }
}

struct FocusableFieldView_Previews: PreviewProvider {
    static var previews: some View {
        FocusableFieldView()
    }
}
