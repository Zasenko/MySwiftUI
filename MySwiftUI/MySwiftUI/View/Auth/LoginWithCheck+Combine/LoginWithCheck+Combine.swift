//
//  LoginWithCheckCombineView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 23.03.23.
//

import SwiftUI

struct LoginWithCheckCombineView: View {
    
    @ObservedObject private var userViewModel = LoginWithCheckCombineViewModel()
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        NavigationView {
            Form() {
                Section(header: Text("Create your password").font(.caption)) {
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $userViewModel.password)
                        } else {
                            SecureField("Password", text: $userViewModel.password)
                        }
                        
                        Spacer().frame(width: 10)
                        
                        Button(action: {}, label: {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor( isPasswordVisible ? .green : .gray)
                                .frame(width: 20, height: 20, alignment: .center)
                        })
                        .onTapGesture { self.isPasswordVisible.toggle() }
                    }
                    
                    List(userViewModel.validations) { validation in
                        HStack {
                            Image(systemName: validation.state == .success ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(validation.state == .success ? Color.green : Color.gray.opacity(0.3))
                            Text(validation.validationType.message(fieldName: validation.field.rawValue))
                                .strikethrough(validation.state == .success)
                                .font(Font.caption)
                                .foregroundColor(validation.state == .success ? Color.gray : .black)
                        }
                        .padding([.leading], 15)
                    }
                }
                
                Section {
                    Button(action: {
                        // Action...
                    }){
                        HStack(alignment: .center) {
                            Spacer()
                            Image(systemName: userViewModel.isValid ? "lock.open.fill" : "lock.fill")
                            Text("Create")
                            Spacer()
                        }
                    }
                    .disabled(!userViewModel.isValid)
                    .animation(.default)
                }
            }
            .listStyle(GroupedListStyle())
        }
    }
}

struct LoginWithCheck_Combine_Previews: PreviewProvider {
    static var previews: some View {
        LoginWithCheckCombineView()
    }
}



