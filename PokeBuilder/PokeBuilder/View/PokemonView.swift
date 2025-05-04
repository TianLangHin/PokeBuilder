//
//  PokemonView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI

struct PokemonView: View {

    @ObservedObject var pokemonData: PokemonDataViewModel

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            if let pokemon = pokemonData.data {
                VStack {
                    Text("\(pokemon.name)")
                        .font(.largeTitle)
                    AsyncImage(url: pokemon.sprite)
                    Text("\(pokemon.stats)")
                    Text("\(pokemon.types.map({ $0.name }))")
                    List(pokemon.moves, id: \.url) { pokemonMove in
                        Text("\(pokemonMove.name)")
                    }
                }
            } else {
                Text("Loading")
            }
        }
    }
}

#Preview {
    PokemonView(pokemonData: PokemonDataViewModel(name: "kyogre"))
}
