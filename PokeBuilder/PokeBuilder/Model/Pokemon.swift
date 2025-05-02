//
//  Pokemon.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 29/4/2025.
//

import SwiftUI

struct Team: Identifiable {
    // To make each team identifiable, enabling its display in a List.
    let id = UUID()

    // Domain-specific logic: Each team has maximum 6 Pokémon.
    static let maximumPokemon = 6

    var pokemon: [Pokemon]

    func addPokemon(pokemon: Pokemon) {
        self.pokemon.append(pokemon)
    }

    func deletePokemon(pokemon: Pokemon) {
        guard let index = self.pokemon.firstIndex(where: {$0.id == pokemon.id}) else {return}
        self.pokemon.remove(at: index)
    }

    func numPokemon() -> Int {
        return self.pokemon.count
    }
}

struct Pokemon: Identifiable {
    // To make each Pokemon within a team identifiable,
    // smoothing over any problems with displaying in a List.
    let id = UUID()

    // Domain-specific logic: Each Pokémon has maximum 4 moves.
    static let maximumMoves = 4

    // Each of the members below (except `stats`) are integers,
    // which are used to lookup the PokéAPI to load full information.

    // Only the `name` is mandatory.
    // The rest of the members can be filled in one by one by the user.
    var pokedexNum: Int
    var ability: String?
    var item: Int?
    var moves: [Int]
    var nature: Int?

    var stats: StatSpread

    func getMoves() -> [Int] {
        return self.moves
    }
}

// A separate `StatSpread` struct makes the declaration of EVs
// in each Pokemon as succinct in the code as possible.
struct StatSpread {

    // Domain-specific logic: Each Pokémon can be allocated maximum 510 EVs.
    static let maximumAllocation = 510

    var hitPoints: Int
    var attack: Int
    var defense: Int
    var specialAttack: Int
    var specialDefense: Int
    var speed: Int
}
