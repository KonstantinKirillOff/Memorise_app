//
//  Cardify.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 13.04.2022.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstant.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstant.lineWidth)
            } else {
                shape.fill()
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (1, 0, 0))
    }
    
    private struct DrawingConstant {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 4
    }
}

extension View {
    func cardify(isFacedUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFacedUp))
    }
}
