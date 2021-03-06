//
//  Memorise_appApp.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 31.01.2022.
//

import SwiftUI

@main
struct Memorise_appApp: App {
   private let game = MemoryGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGame(viewModel: game)
        }
    }
}
