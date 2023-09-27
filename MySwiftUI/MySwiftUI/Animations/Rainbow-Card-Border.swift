//
//  Rainbow-Card-Border.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 03.08.23.
//

import SwiftUI

struct Rainbow_Card_Border: View {
    @State var rotation: CGFloat = 0.0
    
    var body: some View{
        ZStack {
            Color.black
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 500, height: 500)
                .foregroundStyle(LinearGradient(gradient: Gradient (colors: [.red, .orange, .yellow, .green, .blue, .purple, .pink]), startPoint: .top, endPoint: .bottom))
                .rotationEffect(.degrees (rotation))
                .mask {
                    RoundedRectangle (cornerRadius: 20, style: .continuous)
                        .stroke(lineWidth: 1)
                        .frame(width: 210, height: 310)
                   //     .blur(radius: 10)
                }
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 200, height: 300)
                .foregroundColor(.white)
            
//            RoundedRectangle(cornerRadius: 20, style: .continuous)
//                .frame(width: 500, height: 448)
//                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .pink]), startPoint: .top, endPoint: .bottom))
//                .rotationEffect(.degrees(rotation))
//                .mask {
//                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                        .stroke(lineWidth: 3)
//                        .frame(width: 256, height: 336)
//                }
            Image("poster1")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//            Text("CARD")
//                .bold()
//                .font(.largeTitle)
//                .foregroundColor(.primary)
            
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

struct Rainbow_Card_Border_Previews: PreviewProvider {
    static var previews: some View {
        Rainbow_Card_Border()
    }
}
