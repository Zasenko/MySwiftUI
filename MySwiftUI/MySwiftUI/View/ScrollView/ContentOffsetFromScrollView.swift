//
//  ContentOffsetFromScrollView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 08.05.23.
//

import SwiftUI

struct ContentOffsetFromScrollView: View {
    
    @State private var scrollViewContentOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            GeometryReader { outsideProxy in
                Color.red
                    .ignoresSafeArea()
                ScrollView {
                    GeometryReader { insideProxy in
                        Text("\(outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY)")
                            .font(.title)
                            .frame(maxWidth: .infinity) // Just to center the text
                    }
                }
            }
        }
    }
}

struct ContentOffsetFromScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ContentOffsetFromScrollView()
    }
}
