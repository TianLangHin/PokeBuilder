//
//  PokemonCacheViewModel.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI

class PokemonCacheViewModel: ObservableObject, Observable {
    @Published var pokemonList: [PokemonApiData]

    let jsonDecoder = JSONDecoder()

    init() {
        self.pokemonList = []
        Task {
            do {
                let pagingUrl = URL(string: "https://pokeapi.co/api/v2/pokemon-species/")!
                let pagingResponse = try? await URLSession.shared.data(from: pagingUrl)
                guard let (pagingData, _) = pagingResponse else {
                    return
                }
                guard let pokemonCount = try? jsonDecoder.decode(PokemonCount.self, from: pagingData) else {
                    return
                }
                for pokemonIndex in 1...pokemonCount.count {
                    let pokemonUrl = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonIndex)")!
                    let pokemonResponse = try? await URLSession.shared.data(from: pokemonUrl)
                    guard let (data, _) = pokemonResponse else {
                        continue
                    }
                    if let pokemonData = try? jsonDecoder.decode(PokemonApiData.self, from: data) {
                        self.pokemonList.append(pokemonData)
                    }
                }
            }
        }
    }
}

private struct PokemonCount: Codable {
    let count: Int
}
