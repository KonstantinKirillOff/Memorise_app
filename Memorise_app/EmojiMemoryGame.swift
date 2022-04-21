//
//  ContentView.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 31.01.2022.
//

import SwiftUI

struct EmojiMemoryGame: View {
    @ObservedObject var viewModel: MemoryGameViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                button(name: "Change") {
                    viewModel.changeTheme()
                }
                Text("Score: \(viewModel.totalScore)")
                    .font(.largeTitle)
                button(name: "Shuffle") {
                    viewModel.shuffle()
                }
            }
            gameBody
            .padding()
            Spacer()
            VStack(alignment: .center) {
                Text("Theme: \(viewModel.currentTheme.name)")
                    .font(.largeTitle)
            }
        }
    }
    
    var gameBody: some View {
        AspectVGridView(items: viewModel.cards, aspectRatio: 2/3) { card in
            if card.isMatched && !card.isFaceUp {
                Rectangle().opacity(0)
            } else {
                CardView(card: card).padding(4)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 2)) {
                            viewModel.choose(card)
                        }
                    }
                }
        }
        .foregroundColor(viewModel.color)
    }
    
    struct button: View {
        var name: String
        var action: () -> Void
        
        var body: some View {
            Button(action: {
                withAnimation(.easeInOut(duration: 1)) {
                    action()
                }}) {
                    Text("\(name)")
                        .font(.title)
                        .padding(10)
                        .background(Capsule().stroke(Color.blue, lineWidth: 3))
                }
        }
    }
}



struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: 110 - 90))
                    .padding(DrawingConstant.padding)
                    .opacity(DrawingConstant.opacityContent)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstant.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFacedUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstant.fontSize / DrawingConstant.scale)
    }
    
    private struct DrawingConstant {
        static let padding: CGFloat = 6
        static let opacityContent: CGFloat = 0.5
        static let fontSize: CGFloat = 32
        static let scale: CGFloat = 0.5
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = MemoryGameViewModel()
        game.choose(game.cards.first!)
        
        return EmojiMemoryGame(viewModel: game)
    }
}



