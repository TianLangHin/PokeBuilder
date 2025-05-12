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

    // The `PokemonData` struct already contains the fundamental information
    // specific to a Pokemon species, hence that is immutable.
    // Meanwhile, the moveset and stat spread is customisable, hence those are mutable.
    let baseData: PokemonData
    var chosenMoves = [PokemonMove]()
    var statSpread = StatSpread()

    // Domain-specific logic to convert `kebab-case` API names to standard Pokemon names.
    // We provide both a static function that operates just on name strings
    // for external ViewModels to list readable Pokemon names when converted from `names.txt`.
    // We also provide an instance method to simplify calling syntax in some areas.

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
        // If the name is any one of the explicitly coded exceptions above,
        // we get the new name from the lookup table.
        if let newName = customNames[pokemonName] {
            return newName
        } else {
            // Otherwise, we remove hyphens and capitalise words.
            return pokemonName.replacingOccurrences(of: "-", with:" ").capitalized
        }
    }

    func formatName() -> String {
        return Pokemon.formatName(pokemonName: self.baseData.name)
    }
}
