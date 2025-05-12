//
//  Team.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 5/5/2025.
//

import SwiftUI

// This model represents a team of 0-6 Pokemon.
struct Team: Identifiable {

    // To make each team identifiable, enabling its display in a List.
    let id = UUID()

    let name: String

    // Domain-specific logic: Each team has maximum 6 Pokémon.
    static let maximumPokemon = 6

    var pokemon: [Pokemon] = []

    func numPokemon() -> Int {
        return self.pokemon.count
    }

    // Custom functions to manipulate the array of Pokemon contained
    // for cleaner logic when called from Views or ViewModels.
    mutating func addPokemon(pokemon: Pokemon) {
        self.pokemon.append(pokemon)
    }

    mutating func clear() {
        self.pokemon.removeAll()
    }
}
