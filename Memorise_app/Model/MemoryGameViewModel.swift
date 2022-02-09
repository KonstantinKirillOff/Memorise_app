//
//  EmojiMemoruGame.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 05.02.2022.
//

import SwiftUI

class MemoryGameViewModel: ObservableObject {
    static let ikons = ["😁", "😇", "🤬", "🤓", "😎",
                 "😥", "🥶", "🥵", "🤗", "😱",
                 "🤯", "😝", "😶‍🌫️", "🤩", "🥳", "🥺"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String> (numberOfPairsCards: 4) { pairIndex in
           return ikons[pairIndex] }
    }
    
    @Published private var model: MemoryGame<String> = createMemoryGame()
        
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    //MARK: Intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choseCard(card)
    }
}
