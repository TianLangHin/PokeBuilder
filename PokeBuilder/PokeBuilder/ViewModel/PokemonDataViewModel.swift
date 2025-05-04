//
//  PokemonDataViewModel.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 4/5/2025.
//

import SwiftUI

class PokemonDataViewModel: ObservableObject, Observable {
    @Published var data: PokemonData?

    let jsonDecoder = JSONDecoder()

    init(name: String) {
        Task {
            let requestUrl = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")!
            let response = try? await URLSession.shared.data(from: requestUrl)
            guard let (data, _) = response else {
                self.data = nil
                return
            }
            let pokemonData = try? jsonDecoder.decode(PokemonData.self, from: data)
            guard let validData = pokemonData else {
                self.data = nil
                return
            }
            self.data = validData
        }
    }
}
