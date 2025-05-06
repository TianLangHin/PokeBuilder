//
//  FuzzyFinderView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 5/5/2025.
//

import SwiftUI

struct FuzzyFinderView: View {
    
    @StateObject var fuzzyFinder = FuzzyFinderViewModel()
    @StateObject var pokemonLoader = PokemonLoaderViewModel()
    @Binding var team: Team

    @Environment(\.dismiss) var dismiss
    @State var query = ""
    
    var body: some View {
        VStack {
            Text("New Pokémon")
                .font(.title)
                    .padding()
            TextField("Search here", text: $query)
                .padding()
                .autocapitalization(.none)
            List(fuzzyFinder.filterOnSubstring(query: query), id: \.self) { pokemon in
                Button(action: {
                    Task {
                        if let pokeNumber = fuzzyFinder.apiNumber(name: pokemon) {
                            let pokeData = await pokemonLoader.getData(pokemonNumber: pokeNumber)
                            if let pokemonObject = pokeData {
                                team.addPokemon(pokemon: Pokemon(baseData: pokemonObject))
                            }
                        }
                        dismiss()
                    }
                }) {
                    HStack {
                        AsyncImage(url: getSpriteUrl(pokemon: pokemon))
                        Text("\(pokemon)")
                    }
                }
            }
        }
        .padding()
    }
    
    private func getSpriteUrl(pokemon: String) -> URL? {
        guard let number = fuzzyFinder.apiNumber(name: pokemon) else {
            return nil
        }
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(number).png"
        return URL(string: urlString)
    }
}
