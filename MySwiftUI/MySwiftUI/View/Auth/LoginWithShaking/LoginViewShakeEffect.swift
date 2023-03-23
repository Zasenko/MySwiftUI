//
//  LoginViewShakeEffect.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 23.03.23.
//

import SwiftUI

struct LoginViewShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 6
    var numOfShakes: CGFloat = 4
    var animatableData: CGFloat
    
    init(travelDistance: CGFloat = 6, numOfShakes: CGFloat = 4, animatableData: CGFloat) {
        self.travelDistance = travelDistance
        self.numOfShakes = numOfShakes
        self.animatableData = animatableData
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: travelDistance * sin(animatableData * .pi * numOfShakes), y: 0))
    }
}
