//
//  WebViewButtons.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 27.12.22.
//

import SwiftUI

struct WebViewButtons: View {
    var body: some View {
        VStack {
            Link (destination: URL(string: "https://www.linkedin.com/in/eyucherin/")!){
                Text("Linkedin")
                    .font(.system(size: 20))
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            
            
            
            Text("Github")
                   .font(.system(size: 20))
                   .padding()
                   .background(Color.orange)
                   .foregroundColor(.white)
                   .cornerRadius(5)
                   .onTapGesture {
                       UIApplication.shared.open(URL(string: "https://github.com/eyucherin?tab=repositories")!, options: [:])
                   }
            
            WebView()
        }
    }
}

struct WebViewDefault_Previews: PreviewProvider {
    static var previews: some View {
        WebViewButtons()
    }
}
