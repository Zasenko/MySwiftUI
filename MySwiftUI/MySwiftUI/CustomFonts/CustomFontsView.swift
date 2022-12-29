//
//  CustomFontsView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 29.12.22.
//

import SwiftUI

struct CustomFontsView: View {
    var body: some View {
        
        VStack {
            Text("1. In App Main File: Targets - Info - add Fonts provided by Application")
            Image("CustomFonts1")
                .resizable()
                .scaledToFit()
            Text("2. In Info.plist add new Item (String) - fileName.ttf")
            Image("CustomFonts2")
                .resizable()
                .scaledToFit()
            Text("3. Font file shoude have App Target")
            Spacer()
            Text("HELLO")
                .font(Font.custom("Equinox Bold", size: 50, relativeTo: .title))
            Text(" мир!")
                .font(Font.custom("appetite", size: 50, relativeTo: .title))
            Spacer()
                
        }
    }
}

struct CustomFontsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomFontsView()
    }
}
