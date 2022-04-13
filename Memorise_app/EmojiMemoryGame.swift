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
            Text("Score: \(viewModel.totalScore)")
                .font(.largeTitle)
            AspectVGridView(items: viewModel.cards, aspectRatio: 2/3) { card in
                if card.isMatched && !card.isFaceUp {
                    Rectangle().opacity(0)
                } else {
                    CardView(card: card).padding(4)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
            .foregroundColor(viewModel.color)
            .padding()
            Spacer()
            HStack {
                Text("Theme: \(viewModel.currentTheme.name)")
                    .font(.largeTitle)
                Spacer()
                Button(action: {
                    withAnimation {
                        viewModel.changeTheme()
                    }}) {
                        Text("Change")
                            .font(.title)
                            .padding(10)
                            .background(Capsule().stroke(Color.blue, lineWidth: 3))
                    }
            }
            .padding(.horizontal)
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
                    .font(font(in: geometry.size))
            }
            .cardify(isFacedUp: card.isFaceUp)
        }
    }
    
    private struct DrawingConstant {
        static let scale: CGFloat = 0.5
        static let padding: CGFloat = 5
        static let opacityContent: CGFloat = 0.5
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstant.scale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = MemoryGameViewModel()
        game.choose(game.cards.first!)
        
        return EmojiMemoryGame(viewModel: game)
    }
}



