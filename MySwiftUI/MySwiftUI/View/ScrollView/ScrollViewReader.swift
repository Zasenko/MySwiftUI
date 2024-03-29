//
//  ScrollViewReader.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 13.01.23.
//

import SwiftUI

struct ScrollViewReaderSimple: View {
    
    @Namespace var topID
    @Namespace var bottomID
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack {
                    VStack(spacing: 0) {
                        ForEach(0..<200) { i in
                            color(fraction: Double(i) / 100)
                                .frame(height: 50)
                        }
                    }
                    VStack {
                        Button("Scroll to Bottom") {
                            withAnimation {
                                proxy.scrollTo(bottomID)
                            }
                        }
                        .id(topID)
                        Spacer()
                        Button("Top") {
                            withAnimation {
                                proxy.scrollTo(topID)
                            }
                        }
                        .id(bottomID)
                    }
                }
                
                
                
                
            }
        }
    }
    
    func color(fraction: Double) -> Color {
        Color(red: fraction, green: 1 - fraction, blue: 0.5)
    }
}

struct ScrollViewReaderSimple_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReaderSimple()
    }
}
