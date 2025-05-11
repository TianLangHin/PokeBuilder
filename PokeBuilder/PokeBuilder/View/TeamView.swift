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
                List {
                    ForEach($team.pokemon) { $pokemon in
                        NavigationLink(destination: PokemonView(pokemon: $pokemon, listMove: pokemon.baseData.moves)) {
                            TeamMemberView(pokemon: $pokemon)
                        }
                        .listRowBackground(pokemon.baseData.types[0].getBackgroundColour())
                    }
                    .onDelete(perform: deletePokemon)
                }
                .scrollContentBackground(.hidden)
                                
            }
            Spacer()
            HStack {
                NavigationLink(destination: AnalysisView(team: team)) {
                    Text("Analyse Team")
                }
                Spacer()
                if team.pokemon.count < Team.maximumPokemon {
                    NavigationLink(destination: FuzzyFinderView(team: $team)) {
                        Text("Add Pokemon")
                    }
                }
            }
        }
        .padding()
        .toolbarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(team.name)")
                    .font(.largeTitle)
            }
        }
    }

    // Function to delete pokemon
    func deletePokemon(at offsets: IndexSet) {
        team.pokemon.remove(atOffsets: offsets)
    }
}

// Need to find a way to dynamically refresh each item in the list to make the move appear when clicking `back`
struct TeamMemberView: View {
    @Binding var pokemon: Pokemon

    @State var move1: String = ""
    @State var move2: String = ""
    @State var move3: String = ""
    @State var move4: String = ""

    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: pokemon.baseData.sprite)
                    .padding()
                Text("\(pokemon.formatName())")
                    .foregroundColor(pokemon.baseData.types[0].getForegroundColour())
            }
            .padding(.trailing, -10)

            Spacer()

            VStack {
                HStack {
                    Text("\(typeDisplay(pos: 0, empty: "unknown"))")
                        .foregroundColor(overallForegroundColour())
                        .lineLimit(1)
                        .frame(width: 70)
                    
                    Text("\(typeDisplay(pos: 1, empty: ""))")
                        .foregroundColor(overallForegroundColour())
                        .lineLimit(1)
                        .frame(width: 70)
                }
                .padding()

                VStack {
                    Text("\(move1)")
                        .foregroundColor(overallForegroundColour())
                    Text("\(move2)")
                        .foregroundColor(overallForegroundColour())
                    Text("\(move3)")
                        .foregroundColor(overallForegroundColour())
                    Text("\(move4)")
                        .foregroundColor(overallForegroundColour())
                }
            }
        }
        .onAppear() {
            move1 = moveDisplay(pos: 0, empty: "")
            move2 = moveDisplay(pos: 1, empty: "")
            move3 = moveDisplay(pos: 2, empty: "")
            move4 = moveDisplay(pos: 3, empty: "")
        }
    }

    func overallForegroundColour() -> Color {
        return pokemon.baseData.types[0].getForegroundColour()
    }

    func typeDisplay(pos: Int, empty: String) -> String {
        let types = pokemon.baseData.types
        if types.count > pos {
            let type = types[pos].name
            return type.capitalized
        } else {
            return empty
        }
    }

    func moveDisplay(pos: Int, empty: String) -> String {
        let moves = pokemon.chosenMoves
        if moves.count > pos {
            return moves[pos].formatMove()
        } else {
            return empty
        }
    }
}
