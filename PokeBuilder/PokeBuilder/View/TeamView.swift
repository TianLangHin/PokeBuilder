//
//  TeamView.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 2/5/2025.
//

import SwiftUI

struct TeamView : View {
    @Binding var team: Team
    @Binding var teamName: String

    @ObservedObject var pokemonData: PokemonCacheViewModel

    @State var addPokemonEnabled: //Needs to be fixed

    var body: some View {
        NavigationView {
            Text(teamName)
            List {
                ForEach(team) { pokemon in
                    NavigationLink(destination: PokemonView(pokemon: pokemon)) {
                        HStack {
                            VStack {
                                Text("\(pokemon.pokedexNum)") //To be replaced by the pokemon name
                                //AsyncImage(url: pokemon.sprite)
                            }
                            VStack {
                                for move in pokemon.getMoves {
                                    Text("\(move)")
                                }
                            }
                        }
                    }
                }
            } 
        }
    }
}
