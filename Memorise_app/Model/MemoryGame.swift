//
//  MemoryGame.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 05.02.2022.
//

import Foundation

struct MemoryGame <CardContent> {
    private (set) var cards: [Card]
    
    func choseCard(_ card: Card) {
        //card.isFaceUp.toggle()
    }
    
    init(numberOfPairsCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        
        for pairIndex in 0..<numberOfPairsCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    struct Card {
        var content: CardContent
        var isFaceUp = false
        var isMatched = false
    }
}
