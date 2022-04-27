//
//  ContentView.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 31.01.2022.
//

import SwiftUI

struct EmojiMemoryGame: View {
    @ObservedObject var viewModel: MemoryGameViewModel
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                VStack(spacing: 10) {
                    Text("Theme: \(viewModel.currentTheme.name)")
                        .font(.largeTitle)
                    Text("Score: \(viewModel.totalScore)")
                        .font(.largeTitle)
                }
                .padding(.horizontal)
                gameBody
                HStack {
                    button(name: "Change") {
                        dealt.removeAll()
                        viewModel.changeTheme()
                    }
                    Spacer()
                    button(name: "Shuffle") {
                        viewModel.shuffle()
                    }
                }
            }.padding()
            deckBody
        }
    }
    
    var gameBody: some View {
        AspectVGridView(items: viewModel.cards, aspectRatio: DrawingConstant.aspectRatio) { card  in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Rectangle().opacity(0)
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(reverceZindex(card))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: DrawingConstant.animationDuration)) {
                            viewModel.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(viewModel.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(viewModel.cards.filter({ isUndealt($0) })) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(reverceZindex(card))
            }
        }
        .frame(width: DrawingConstant.undealWidth, height: DrawingConstant.undealHeight)
        .foregroundColor(viewModel.color)
        .onTapGesture{
            for card in viewModel.cards {
                    withAnimation(dealAnimation(card)) {
                    dealt.insert(card.id)
                }
            }
        }
    }
    
    struct button: View {
        var name: String
        var action: () -> Void
        
        var body: some View {
            Button(action: {
                withAnimation(.easeInOut(duration: DrawingConstant.animationDuration)) {
                    action()
                }}) {
                    Text("\(name)")
                        .font(.title)
            }
        }
    }
    
    
    private func isUndealt(_ card: MemoryGameViewModel.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(_ card: MemoryGameViewModel.Card) -> Animation {
        var delay = 0.0
        
        if let indexCard = viewModel.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(indexCard) * ( DrawingConstant.animationDuration / Double(viewModel.cards.count) )
        }
        
        return Animation.easeInOut(duration: DrawingConstant.animationDuration).delay(delay)
    }
    
    private func reverceZindex(_ card: MemoryGameViewModel.Card) -> Double {
        -Double(viewModel.cards.firstIndex(where: { $0.id == card.id } ) ?? 0 )
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    @State private var animatedBonusRemining = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - animatedBonusRemining) * 360 - 90))
                            .onAppear {
                                animatedBonusRemining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 -  card.bonusRemaining) * 360 - 90))
                    }
                }
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
}

struct DrawingConstant {
    static let padding: CGFloat = 6
    static let opacityContent: CGFloat = 0.5
    static let fontSize: CGFloat = 32
    static let scale: CGFloat = 0.5
    static let aspectRatio: CGFloat = 2/3
    static let undealHeight: CGFloat = 90
    static let undealWidth: CGFloat = undealHeight * aspectRatio
    static let animationDuration: CGFloat = 1
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = MemoryGameViewModel()
        game.choose(game.cards.first!)
        
        return EmojiMemoryGame(viewModel: game)
    }
}



