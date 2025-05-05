//
//  FuzzyFinderView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 5/5/2025.
//

import SwiftUI

struct FuzzyFinderView: View {
    
    @StateObject var fuzzyFinder = FuzzyFinderViewModel()
    @ObservedObject var teamList: TeamListViewModel
    @State var id: UUID
    
    @Environment(\.dismiss) var dismiss
    @State var query = ""
    
    var body: some View {
        VStack {
            if let index = teamList.userTeams.firstIndex(where: {$0.id == id}) {
                Text("New Pokémon")
                    .font(.title)
                    .padding()
                TextField("Search here", text: $query)
                    .padding()
                    .autocapitalization(.none)
                List(fuzzyFinder.filterOnSubstring(query: query), id: \.self) { pokemon in
                    Button(action: {
                        let pokeData = PokemonDataViewModel(name: pokemon)
                        if let pokemonObject = pokeData.data {
                            teamList.userTeams[index]
                                .addPokemon(pokemon: Pokemon(baseData: pokemonObject))
                        }
                        dismiss()
                    }) {
                        HStack {
                            AsyncImage(url: getSpriteUrl(pokemon: pokemon))
                            Text("\(pokemon)")
                        }
                    }
                }
            } else {
                Text("No team to add to. Please return.")
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
