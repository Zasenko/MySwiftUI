//
//  WebView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 27.12.22.
//

import SwiftUI

struct WebView: View {
@State private var showSafari: Bool = false
var body: some View {
   Text("Medium")
          .font(.system(size: 20))
          .padding()
          .background(Color.green)
          .foregroundColor(.white)
          .cornerRadius(5)
          .onTapGesture{
              showSafari.toggle()
          }
          .fullScreenCover(isPresented: $showSafari, content: {
                  SafariView(url: URL(string: "https://medium.com/me/stories/public")!)
          })
      }
  }
struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}

