//
//  ContentView.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 31.01.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var ikons:[String] = ["😁", "😇", "🤬", "🤓", "😎",
                                         "😥", "🥶", "🥵", "🤗", "😱",
                                         "🤯", "😝", "😶‍🌫️", "🤩", "🥳", "🥺"].shuffled()
    
    let rowsInGreed = [
        GridItem(.adaptive(minimum: 85))]
    
    var body: some View {
        VStack {
            Text("Memorise!")
                .font(.system(size: 45))
            ScrollView {
                LazyVGrid(columns: rowsInGreed) {
                    ForEach(ikons[0..<Int.random(in: 1...16)], id: \.self) { ikon in
                        CardView(content: ikon)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
            Spacer()
            HStack {
                cars
                Spacer()
                emojis
                Spacer()
                animals
            }
            .font(.largeTitle)
            .padding(.horizontal, 40)
        }
        .padding(.horizontal)
    }
    
    
    var cars: some View {
        Button(action: {
            ikons = ["🚛", "🚂", "🚜", "🚓", "🚑",
                     "✈️", "🚔", "🛵", "🚀", "🛸",
                     "🚁", "🛶", "🚨", "🛴", "⚓️", "🚧"].shuffled()
        }) {
            VStack {
                Image(systemName: "car.fill")
                Text("cars")
                    .font(.system(size: 20))
            }
        }
    }
    
    var emojis: some View {
        Button(action: {
            ikons = ["😁", "😇", "🤬", "🤓", "😎",
                     "😥", "🥶", "🥵", "🤗", "😱",
                     "🤯", "😝", "😶‍🌫️", "🤩", "🥳", "🥺"].shuffled()
        }) {
            VStack {
                Image(systemName: "face.smiling.fill")
                Text("emojis")
                    .font(.system(size: 20))
            }
        }
    }
    
    
    var animals: some View {
        Button(action: {
            ikons = ["🐥", "🐒", "🐧", "🐺", "🪲",
                     "🦞", "🦀", "🐬", "🐍", "🐌",
                     "🦖", "🦕", "🐙", "🦄", "🐶", "🐡"].shuffled()
        }) {
            VStack {
                Image(systemName: "pawprint.fill")
                Text("animals")
                    .font(.system(size: 20))
            }
        }
    }
    
  
}


struct CardView: View {
    @State private var isFaceUp = true
    var content: String
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 25)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            self.isFaceUp.toggle()
        }
    }
}









struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
.previewInterfaceOrientation(.portraitUpsideDown)
        ContentView()
            .preferredColorScheme(.light)
    }
}


//@State private var countOfCards = 15
//var remove: some View {
//    Button(action: { countOfCards -= 1 }) {
//        Image(systemName: "minus.circle")
//    }
//}
//
//var add: some View {
//    Button(action: { countOfCards += 1 }) {
//        Image(systemName: "plus.circle")
//    }
//}
//
//var shufle: some View {
//    Button("Shufle") {
//        transports.shuffle()
//    }
//}
