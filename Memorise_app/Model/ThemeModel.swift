//
//  ThemeModel.swift
//  Memorise_app
//
//  Created by Konstantin Kirillov on 14.02.2022.
//

import Foundation

struct Theme: Identifiable {
    var id = UUID()
    var name: String
    var emojis: [String]
    var cardPairCount: Int
    var color: String
}
