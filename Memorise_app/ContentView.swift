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
            Text("Memorise!")
                .font(.system(size: 45))
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
            .foregroundColor(.red)
        }
        .padding(.horizontal)
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
        
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
.previewInterfaceOrientation(.portraitUpsideDown)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)
    }
}


//var cars: some View {
//    Button(action: {
//        ikons = ["🚛", "🚂", "🚜", "🚓", "🚑",
//                 "✈️", "🚔", "🛵", "🚀", "🛸",
//                 "🚁", "🛶", "🚨", "🛴", "⚓️", "🚧"].shuffled()
//    }) {
//        VStack {
//            Image(systemName: "car.fill")
//            Text("cars")
//                .font(.system(size: 20))
//        }
//    }
//}
//
//var emojis: some View {
//    Button(action: {
//        ikons = ["😁", "😇", "🤬", "🤓", "😎",
//                 "😥", "🥶", "🥵", "🤗", "😱",
//                 "🤯", "😝", "😶‍🌫️", "🤩", "🥳", "🥺"].shuffled()
//    }) {
//        VStack {
//            Image(systemName: "face.smiling.fill")
//            Text("emojis")
//                .font(.system(size: 20))
//        }
//    }
//}
//
//
//var animals: some View {
//    Button(action: {
//        ikons = ["🐥", "🐒", "🐧", "🐺", "🪲",
//                 "🦞", "🦀", "🐬", "🐍", "🐌",
//                 "🦖", "🦕", "🐙", "🦄", "🐶", "🐡"].shuffled()
//    }) {
//        VStack {
//            Image(systemName: "pawprint.fill")
//            Text("animals")
//                .font(.system(size: 20))
//        }
//    }
//}
