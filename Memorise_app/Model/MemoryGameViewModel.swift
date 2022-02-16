//
//  EmojiMemoruGame.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 05.02.2022.
//

import SwiftUI

class MemoryGameViewModel: ObservableObject {
    private static var allThemes: [Theme] = generateThemes()
    
    private static func generateThemes() -> [Theme] {
        var themes = [Theme]()
        
        let cars  = ["🚛", "🚂", "🚜", "🚓", "🚑",
                         "✈️", "🚔", "🛵", "🚀", "🛸",
                         "🚁", "🛶", "🚨", "🛴", "⚓️", "🚧"]
  
        let emojis = ["😁", "😇", "🤬", "🤓", "😎"]
  
        let animals = ["🐥", "🐒", "🐧", "🐺", "🪲",
                         "🦞", "🦀", "🐬", "🐍", "🐌",
                         "🦖", "🦕", "🐙", "🦄", "🐶", "🐡"]
        
        let helloween = ["🕸", "👻", "🤡", "☠️", "💀", "👹", "🎃"]
        
        let carTheme = Theme(name: "Cars", emojis: cars, cardPairCount: 12, color: "orange")
        let emojiTheme = Theme(name: "Smile", emojis: emojis, cardPairCount: 10, color: "blue")
        let animalTheme = Theme(name: "Animal", emojis: animals, cardPairCount: 8, color: "green")
        let hellowenTheme = Theme(name: "Helloween", emojis: helloween, cardPairCount: 6, color: "black")
    
        themes.append(carTheme)
        themes.append(emojiTheme)
        themes.append(animalTheme)
        themes.append(hellowenTheme)
        
        return themes
    }
    
    private (set) var currentTheme: Theme {
        didSet {
            model = MemoryGameViewModel.createMemoryGame(with: currentTheme)
        }
    }
    
    @Published private var model: MemoryGame<String>
    
    static func createMemoryGame(with theme: Theme) -> MemoryGame<String> {
        let shuffledEmojis = theme.emojis.shuffled()
        
        return MemoryGame<String> (numberOfPairsCards: min(theme.cardPairCount, theme.emojis.count)) { pairIndex in
            return shuffledEmojis[pairIndex] }
    }
    
    init() {
        let theme = MemoryGameViewModel.allThemes.randomElement()!
        currentTheme = theme
        model = MemoryGameViewModel.createMemoryGame(with: theme)
    }
    

    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    var totalScore: Int {
        model.totalScore
    }
    
    var color: Color {
        return getColorFromCurrentTheme()
    }
    
    func getColorFromCurrentTheme() -> Color {
        switch currentTheme.color {
        case "orange": return Color.orange
        case "blue": return Color.blue
        case "green": return Color.green
        case "black": return Color.black
        default:
            return Color.red
        }
    }
    
    //MARK: Intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choseCard(card)
    }
    
    func changeTheme() {
        currentTheme = MemoryGameViewModel.allThemes.randomElement()!
    }
}