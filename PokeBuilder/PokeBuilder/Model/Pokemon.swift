//
//  Pokemon.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 29/4/2025.
//

import SwiftUI

struct Pokemon: Identifiable {
    // To make each Pokemon within a team identifiable,
    // smoothing over any problems with displaying in a List.
    let id = UUID()
    
    // Domain-specific logic: Each Pokémon has maximum 4 moves.
    static let maximumMoves = 4
    
    let baseData: PokemonData
    var chosenMoves = [PokemonMove]()
    var statSpread = StatSpread()

    static func formatName(pokemonName: String) -> String {
        let customNames = [
            "nidoran-f": "Nidoran (F)",
            "nidoran-m": "Nidoran (M)",
            "farfetch-d": "Farfetch'd",
            "sirfetch-d": "Sirfetch'd",
            "ho-oh": "Ho-Oh",
            "mime-jr": "Mime Jr.",
            "mr-mime": "Mr. Mime",
            "mr-rime": "Mr. Rime",
            "porygon-z": "PorygonZ",
            "jangmo-o": "Jangmo-o",
            "hakamo-o": "Hakamo-o",
            "kommo-o": "Kommo-o",
            "type-null": "Type: Null",
            "wo-chien": "Wo-Chien",
            "chi-yu": "Chi-Yu",
            "chien-pao": "Chien-Pao",
            "ting-lu": "Ting-Lu"
        ]
        if let newName = customNames[pokemonName] {
            return newName
        }
        else {
            return pokemonName.replacingOccurrences(of: "-", with:" ").capitalized
        }
    }

    func formatName() -> String {
        return Pokemon.formatName(pokemonName: self.baseData.name)
    }
}
