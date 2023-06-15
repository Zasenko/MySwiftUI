//
//  SimpleButton.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 15.06.23.
//

import SwiftUI

struct SimpleButton: View {
    
    @State private var isRequesting: Bool = false
    
    var body: some View {
        VStack {
            
            Button {
            } label: {
                Text("automatic")
            }
            .buttonStyle(.automatic) //.buttonStyle(DefaultButtonStyle())
            
            Button {
            } label: {
                Text("plain")
            }
            .buttonStyle(.plain) //.buttonStyle(PlainButtonStyle())
            
            Button {
            } label: {
                Text("bordered")
            }
            .buttonStyle(.bordered) //.buttonStyle(BorderedButtonStyle())
            
            Button {
            } label: {
                Text("tint red")
            }
            .buttonStyle(.bordered)
            .tint(Color.red)
            
            Button {
            } label: {
                Text("borderedProminent tint red")
            }
            .buttonStyle(.borderedProminent) //.buttonStyle(BorderedProminentButtonStyle())
            .tint(Color.red)
            
            Button {
            } label: {
                Text("mini")
            }
            .buttonStyle(.bordered)
            .controlSize(.mini)
            
            Button {
            } label: {
                Text("small")
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            
            Button {
            } label: {
                Text("regular")
            }
            .buttonStyle(.bordered)
            .controlSize(.regular)
            
            Button {
            } label: {
                Text("large underline").underline()
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            
            Button {
                fakeAPIRequest()
            } label: {
                if isRequesting {
                    ProgressView()
                } else {
                    Text("Make API request")
                }
            }
            .disabled(isRequesting ? true : false) //<-- Disable button while requesting
            .buttonStyle(BorderedProminentButtonStyle())
        }
    }
    
    func fakeAPIRequest() {
        withAnimation {
            isRequesting = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isRequesting = false
            }
        }
    }
}

struct SimpleButton_Previews: PreviewProvider {
    static var previews: some View {
        SimpleButton()
    }
}
