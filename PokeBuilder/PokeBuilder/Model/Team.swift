//
//  Team.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 5/5/2025.
//

import SwiftUI

struct Team: Identifiable {
    // To make each team identifiable, enabling its display in a List.
    let id = UUID()

    let name: String

    // Domain-specific logic: Each team has maximum 6 Pokémon.
    static let maximumPokemon = 6

    var pokemon: [Pokemon] = []

    mutating func addPokemon(pokemon: Pokemon) {
        self.pokemon.append(pokemon)
    }

    mutating func deletePokemon(pokemon: Pokemon) {
        guard let index = self.pokemon.firstIndex(where: {$0.id == pokemon.id}) else {return}
        self.pokemon.remove(at: index)
    }

    func numPokemon() -> Int {
        return self.pokemon.count
    }
}
