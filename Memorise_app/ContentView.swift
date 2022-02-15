//
//  ContentView.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 31.01.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MemoryGameViewModel
    
    let rowsInGreed = [
        GridItem(.adaptive(minimum: 85))]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: rowsInGreed) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
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
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 25)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if  card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = MemoryGameViewModel()
        
//        ContentView(viewModel: game)
//            .preferredColorScheme(.dark)
//            .previewInterfaceOrientation(.portrait)
        ContentView(viewModel: game)
            //.preferredColorScheme(.light)
    }
}



