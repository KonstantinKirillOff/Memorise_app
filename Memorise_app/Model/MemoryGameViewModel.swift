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
        
        let carTheme = Theme(name: "Cars", emojis: cars, cardPairCount: 12, color: "orange")
        let emojiTheme = Theme(name: "Smile", emojis: emojis, cardPairCount: 10, color: "blue")
        let animalTheme = Theme(name: "Animal", emojis: animals, cardPairCount: 8, color: "green")
    
        themes.append(carTheme)
        themes.append(emojiTheme)
        themes.append(animalTheme)
        
        return themes
    }
    
    @Published private (set) var theme: Theme
    @Published private var model: MemoryGame<String>
    
    static func createMemoryGame(with theme: Theme) -> MemoryGame<String> {
        MemoryGame<String> (numberOfPairsCards: min(theme.cardPairCount, theme.emojis.count)) { pairIndex in
            return theme.emojis.shuffled()[pairIndex] }
    }
    
    init() {
        theme = MemoryGameViewModel.allThemes.randomElement()!
        model = MemoryGameViewModel.createMemoryGame(with: MemoryGameViewModel.allThemes.randomElement()!)
    }
    

    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    var color: Color {
        return getColorFromCurrentTheme()
    }
    
    func getColorFromCurrentTheme() -> Color {
        switch theme.color {
        case "orange": return Color.orange
        case "blue": return Color.blue
        case "green": return Color.green
        default:
            return Color.red
        }
    }
    
    //MARK: Intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choseCard(card)
    }
    
    func changeTheme() {
        theme = MemoryGameViewModel.allThemes.randomElement()!
        model = MemoryGameViewModel.createMemoryGame(with: theme)
    }
}
