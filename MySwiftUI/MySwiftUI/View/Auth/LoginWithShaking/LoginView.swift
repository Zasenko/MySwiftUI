//
//  LoginView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 23.03.23.
//

import SwiftUI

struct LoginView: View {
    
    private let lightGrey = Color(red: 240.0/255.0,
                                  green: 242.0/255.0,
                                  blue: 245.0/255.0,
                                  opacity: 1.8)
    @State private var username = ""
    @State private var password = ""
    @State private var invalidAttempts = 0
    
    var body: some View {
        VStack {
            Spacer()
            Text("Login")
                .font(.system(size: 40)).bold()
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.secondary)
                TextField("Email", text: $username)
            }
            .padding()
            .background(lightGrey)
            .cornerRadius(8)
            .padding(.bottom, 20)
            .keyboardType(.emailAddress)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.secondary)
                SecureField("Password", text: $password)
            }
            .padding()
            .background(lightGrey)
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundColor(invalidAttempts == 0 ? .clear : .red)
            }
            .padding(.bottom, 20)
            .modifier(LoginViewShakeEffect(animatableData: CGFloat(invalidAttempts)))

            Button {
                //forgot pass
            } label: {
                Text("Forgot password?")
                    .padding()
            }
            

            Button {
                withAnimation(.default) {
                    self.invalidAttempts += 1
                }
            } label: {
                Text ("LOGIN")
                .font(.headline).bold()
                .foregroundColor(.white)
                .padding()
                .frame(width: 250, height: 60)
                .background (Color.blue)
                .cornerRadius(20)
            }
            Spacer()
            HStack {
                Text("Don't have an account?")
                Button {
                    //Sign up
                } label: {
                    Text("Sign Up")
                }

            }
            .padding()
        }
        .padding()
        .background(.yellow)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
