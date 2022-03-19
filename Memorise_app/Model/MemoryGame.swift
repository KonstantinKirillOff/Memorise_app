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
        get {
            let faceUpCardIndicies = cards.indices.filter({ cards[$0].isFaceUp })
            return faceUpCardIndicies.oneAndOnly
        }
        set {
            for index in cards.indices {
                if index != newValue {
                    if cards[index].isFaceUp {
                        viewedCards.insert(cards[index].id)
                    }
                    cards[index].isFaceUp = false
                } else {
                    cards[index].isFaceUp = true
                }
            }
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
    



