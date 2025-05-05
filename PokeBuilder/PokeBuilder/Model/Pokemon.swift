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
    let chosenMoves = [PokemonMove]()
    let statSpread = StatSpread()
}
