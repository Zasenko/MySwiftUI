//
//  DrawingShapeSimple.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 05.08.23.
//

import SwiftUI

struct DrawingShapeSimple: View {
    var body: some View {
        VStack {
            HeartShape()
                .fill(Color.red)
                .frame(width: 200, height: 200)
            Kaplya()
                .stroke(lineWidth: 10)
                .foregroundColor(.black)
                .frame(width: 50, height: 100)
            
        }
    }
}

struct DrawingShapeSimple_Previews: PreviewProvider {
    static var previews: some View {
        DrawingShapeSimple()
    }
}

struct Kaplya: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.size.width / 2, y: rect.size.height), control: CGPoint(x: 0, y: rect.size.height))
            path.addQuadCurve(to: CGPoint(x: rect.size.width, y: 0), control: CGPoint(x: rect.size.width, y: rect.size.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.size.width / 2, y: rect.size.height), control: CGPoint(x: 0, y: rect.size.height))
           // path.addQuadCurve(to: CGPoint(x: rect.size.width, y: 0), control: CGPoint(x: rect.size.width / 2, y: rect.size.height * 2.5))
        }
    }
    
    
}

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            let topCurveHeight = height * 0.3
            let bottomOffset = width * 0.15
            
            path.move(to: CGPoint(x: width / 2, y: 0))
            path.addCurve(
                to: CGPoint(x: width, y: height / 2),
                control1: CGPoint(x: width, y: -topCurveHeight),
                control2: CGPoint(x: width + bottomOffset, y: height / 4)
            )
            path.addCurve(
                to: CGPoint(x: width / 2, y: height),
                control1: CGPoint(x: width - bottomOffset, y: height / 4 * 3),
                control2: CGPoint(x: width / 2, y: height)
            )
            path.addCurve(
                to: CGPoint(x: 0, y: height / 2),
                control1: CGPoint(x: width / 2, y: height),
                control2: CGPoint(x: bottomOffset, y: height / 4 * 3)
            )
            path.addCurve(
                to: CGPoint(x: width / 2, y: 0),
                control1: CGPoint(x: -bottomOffset, y: height / 4),
                control2: CGPoint(x: width / 2, y: -topCurveHeight)
            )
        }
    }
}
