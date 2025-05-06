//
//  PokemonLoaderViewModel.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 4/5/2025.
//

import SwiftUI

class PokemonLoaderViewModel: ObservableObject, Observable {

    let jsonDecoder = JSONDecoder()

    func getData(pokemonNumber: Int) async -> PokemonData? {
        let requestUrl = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonNumber)")!
        let response = try? await URLSession.shared.data(from: requestUrl)
        guard let (data, _) = response else {
            return nil
        }
        let pokemonData = try? jsonDecoder.decode(PokemonData.self, from: data)
        guard let validData = pokemonData else {
            return nil
        }
        return validData
    }
}
