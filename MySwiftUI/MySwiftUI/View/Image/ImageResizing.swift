//
//  ImageResizing.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 20.06.23.
//

import SwiftUI

struct ImageResizing: View {
    
    @State var lastScaleValue: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Image("example")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200, alignment: .center)
                .clipped()
                .scaleEffect(lastScaleValue)
                .gesture(MagnificationGesture().onChanged { val in
                    print(val)
                            self.lastScaleValue = val
                }.onEnded { val in
                    self.lastScaleValue = 1.0
                })
            
            Color.clear
                .border(Color.red)
                .frame(width: 200, height: 200)
        }
        
        
    }
}

struct ImageResizing_Previews: PreviewProvider {
    static var previews: some View {
        ImageResizing()
    }
}
