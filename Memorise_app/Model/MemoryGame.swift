//
//  MemoryGame.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 05.02.2022.
//

import Foundation
import SwiftUI

struct MemoryGame <CardContent> where CardContent: Equatable {
    private (set) var cards: [Card]
    private var viewedCards: Set<Int> = []
    
    private var indexCurrentFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach({
            if cards[$0].isFaceUp {
                viewedCards.insert(cards[$0].id)
            }
            cards[$0].isFaceUp = ($0 == newValue)
            })
        }
    }
    
    private (set) var totalScore: Int = 0
    
    init(numberOfPairsCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<numberOfPairsCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        let content: CardContent
        var isFaceUp = false
        var isMatched = false
        let id: Int
    }
    
    mutating func choseCard(_ card: Card) {
        if let indexCard = cards.firstIndex(where: { $0.id == card.id } ), !cards[indexCard].isFaceUp,!cards[indexCard].isMatched {
            if let potentialMatchedIndex = indexCurrentFaceUpCard {
                if cards[indexCard].content == cards[potentialMatchedIndex].content {
                    cards[indexCard].isMatched = true
                    cards[potentialMatchedIndex].isMatched = true
                    
                    totalScore += 2
                } else {
                    if viewedCards.contains(cards[indexCard].id) {
                        totalScore -= 1
                    }
                    if viewedCards.contains(cards[potentialMatchedIndex].id) {
                        totalScore -= 1
                    }
                }
                cards[indexCard].isFaceUp = true
            } else {
                indexCurrentFaceUpCard = indexCard
            }
        }
    }

}

extension Array {
    var oneAndOnly: Element? {
        self.count == 1 ? self.first : nil
    }
}
    

struct Previews_MemoryGame_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
