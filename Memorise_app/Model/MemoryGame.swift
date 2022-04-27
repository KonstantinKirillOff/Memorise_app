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
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }                
            }
        }
        let id: Int
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
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
    
    mutating func shuffle() {
        cards.shuffle()
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
