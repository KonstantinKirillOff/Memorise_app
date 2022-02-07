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
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
    }
    
    struct Card: Identifiable {
        var content: CardContent
        var isFaceUp = true
        var isMatched = false
        var id: Int
    }
}
