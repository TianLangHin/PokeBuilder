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
            TextField("Search here", text: $query)
                .padding()
                .autocapitalization(.none)
                .autocorrectionDisabled(true)

            // We show the list of Pokemon with names that contain the query string
            // as some subsequence (not necessarily contiguous) to allow convenient searching.
            List(fuzzyFinder.filterOnSubstring(query: query), id: \.self) { pokemon in
                Button(action: {
                    // Each Pokemon that shows up is a Button that adds it to the team.
                    // When a Pokemon is added, this view is to be dismissed immediately
                    // so that the user can see the changes in the team.
                    // This is done by triggering an async task since PokeAPI is called here.
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
                    // Every entry that shows up will show the Pokemon sprite and name.
                    // Since just the name is accessible here, we use the static Pokemon method.
                    HStack {
                        AsyncImage(url: getSpriteUrl(pokemon: pokemon))
                        Text("\(Pokemon.formatName(pokemonName: pokemon))")
                    }
                }
            }
        }
        .padding()
        .padding(.top, -20)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("New Pokémon")
                    .font(.largeTitle)
                    .padding()
            }
        }
    }

    // The PokeAPI responses always provide sprites in the form of a raw GitHub User Content URL,
    // hence we retrieve the images directly rather than having to query PokeAPI for the URL first.
    private func getSpriteUrl(pokemon: String) -> URL? {
        // If somehow an invalid Pokemon is accessed, it should not crash the entire app.
        // Instead, the sprite should simply be a placeholder, and the rest of the app can run smoothly.
        guard let number = fuzzyFinder.apiNumber(name: pokemon) else {
            return nil
        }
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(number).png"
        return URL(string: urlString)
    }
}
