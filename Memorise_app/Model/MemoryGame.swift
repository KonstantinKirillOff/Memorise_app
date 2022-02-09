//
//  MemoryGame.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 05.02.2022.
//

import Foundation

struct MemoryGame <CardContent> where CardContent: Equatable {
    private (set) var cards: [Card]
    
    private var indexCurrentFaceUpCard: Int?
    
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
        var isFaceUp = false
        var isMatched = false
        var id: Int
    }
    
    mutating func choseCard(_ card: Card) {
        if let indexCard = cards.firstIndex(where: { $0.id == card.id } ),
           !cards[indexCard].isFaceUp,
           !cards[indexCard].isMatched {
            if let potentialMatchedIndex = indexCurrentFaceUpCard {
                if cards[indexCard].content == cards[potentialMatchedIndex].content {
                    cards[indexCard].isMatched = true
                    cards[potentialMatchedIndex].isMatched = true
                }
                indexCurrentFaceUpCard = nil
            } else {
                for inndex in 0..<cards.count {
                    cards[inndex].isFaceUp = false
                }
                indexCurrentFaceUpCard = indexCard
            }
            cards[indexCard].isFaceUp.toggle()
            print("\(cards[indexCard])")
        }
    }

}
