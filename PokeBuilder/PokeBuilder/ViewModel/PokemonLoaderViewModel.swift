//
//  PokemonLoaderViewModel.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 4/5/2025.
//

import SwiftUI

// This ViewModel abstracts away the loading of Pokemon data which
// needs to be carried out every time one is added to a team
// (i.e., loading from FuzzyFinderView back into TeamView).
class PokemonLoaderViewModel: ObservableObject, Observable {

    let jsonDecoder = JSONDecoder()

    // Since calling PokeAPI is an async operation, this function is async as well.
    // This call may also potentially fail, in which case it should silently be ignored
    // since multiple of these calls could be happening within the app's lifetime.
    // A single failed API call should not crash the app, and instead be smoothed over
    // to prioritise user experience.
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
