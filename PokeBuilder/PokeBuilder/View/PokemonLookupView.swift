//
//  PokemonLookupView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 2/5/2025.
//

import SwiftUI

struct PokemonLookupView: View {
    @ObservedObject var pokemonData: PokemonCacheViewModel
    var body: some View {
        VStack {
            HStack {
                List(pokemonData.pokemonList) { pokemon in
                    HStack {
                        AsyncImage(url: pokemon.sprite)
                        Text("\(pokemon.name)")
                        Spacer()
                        Text("\(pokemon.stats)")
                    }
                }
            }
        }
    }
}

#Preview {
    PokemonLookupView(pokemonData: PokemonCacheViewModel())
}
