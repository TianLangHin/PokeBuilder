//
//  TeamView.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 2/5/2025.
//

import SwiftUI

struct TeamView: View {

    @Binding var team: Team

    var body: some View {
        VStack {
            VStack {
                Text("\(team.name)")
                    .font(.largeTitle)
                List {
                    ForEach($team.pokemon) { $pokemon in
                        NavigationLink(destination: PokemonView(pokemon: $pokemon)) {
                            TeamMemberView(pokemon: pokemon)
                        }
                    }
                }
            }
            Spacer()
            HStack {
                Spacer()
                if team.pokemon.count < Team.maximumPokemon {
                    NavigationLink(destination: FuzzyFinderView(team: $team)) {
                        Text("Add Pokemon")
                    }
                }
            }
        }
        .padding()
    }
}

struct TeamMemberView: View {
    @State var pokemon: Pokemon
    
    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: pokemon.baseData.sprite)
                    .padding()
                Text("\(pokemon.baseData.name)")
            }
            VStack {
                HStack {
                    Text("\(typeDisplay(pos: 0, empty: "unknown"))")
                    Text("\(typeDisplay(pos: 1, empty: ""))")
                }
                .padding()
                Grid() {
                    GridRow {
                        Text("\(moveDisplay(pos: 0))")
                        Text("\(moveDisplay(pos: 1))")
                    }
                    GridRow {
                        Text("\(moveDisplay(pos: 2))")
                        Text("\(moveDisplay(pos: 3))")
                    }
                }
            }
        }
    }

    func typeDisplay(pos: Int, empty: String) -> String {
        let types = pokemon.baseData.types
        if types.count > pos {
            return types[pos].name
        } else {
            return empty
        }
    }

    func moveDisplay(pos: Int) -> String {
        let moves = pokemon.chosenMoves
        if moves.count > pos {
            return moves[pos].name
        } else {
            return ""
        }
    }
}
