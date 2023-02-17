//
//  FaceIDLoginView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 16.02.23.
//

import SwiftUI

struct TouchIDswiftuiApp: View {
    @StateObject var appContext = AppContext()
    
    var body: some View {
            ZStack {
                if appContext.appUnlocked {
                    Color.red
                } else {
                    FaceIDLoginView(appContext: appContext)
                        .background(Color.white)
                }
            }
            .onAppear() {
                appContext.requestBiometricUnlock()
            }
    }
}


struct FaceIDLoginView: View {

    @ObservedObject var appContext: AppContext
    
        var body: some View {
            VStack(spacing: 24) {
                Image(systemName: "faceid")
                    .resizable()
                    .frame(width: 150, height: 150)
                
                Button(action: {
                    appContext.requestBiometricUnlock()
                }, label: {
                    HStack {
                        Spacer()
                        Text("Login now")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                })
            }
            .padding()
        }
}

struct TouchIDswiftuiApp_Previews: PreviewProvider {
    static var previews: some View {
        TouchIDswiftuiApp()
    }
}
