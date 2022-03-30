//
//  ContentView.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 31.01.2022.
//

import SwiftUI

struct EmojiMemoryGame: View {
    @ObservedObject var viewModel: MemoryGameViewModel
    
    let rowsInGreed = [
        GridItem(.adaptive(minimum: 60))]
    
    var body: some View {
        VStack {
            Text("Score: \(viewModel.totalScore)")
                .font(.largeTitle)
            AspectVGridView(items: viewModel.cards, aspectRatio: 2/3, content: { card in
                CardView(card: card).padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
                
            })
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
                let shape = RoundedRectangle(cornerRadius: DrawingConstant.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstant.lineWidth)
                    Text(card.content).font(font(in: geometry.size))
                } else if  card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        }
    }
    
    private struct DrawingConstant {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 4
        static let scale: CGFloat = 0.7
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstant.scale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = MemoryGameViewModel()
        EmojiMemoryGame(viewModel: game)
    }
}



