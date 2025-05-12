//
//  TeamView.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 2/5/2025.
//

import SwiftUI

// This is the main view containing all information when viewing a specific team
// (that is, when the team is selected from the parent view).
struct TeamView: View {

    // The team being dealt with here is passed by the parent view.
    @Binding var team: Team

    var body: some View {
        VStack {
            // First, the main view shows a scrollable list of all Pokemon in the team.
            VStack {
                List {
                    ForEach($team.pokemon) { $pokemon in
                        NavigationLink(destination: PokemonView(pokemon: $pokemon, moveList: pokemon.baseData.moves)) {
                            TeamMemberView(pokemon: $pokemon)
                        }
                        .listRowBackground(pokemon.baseData.types[0].getBackgroundColour())
                    }
                    .onDelete(perform: deletePokemon)
                }
                .scrollContentBackground(.hidden)
            }

            Spacer()

            // At the bottom of the screen, we provide two functionalities:
            // One for a moving to the team analysis page, and one for adding a new Pokemon.
            // The `New Pokemon` button will disappear if the maximum team size has been reached.
            HStack {
                NavigationLink(destination: AnalysisView(team: team)) {
                    Text("Analyse Team")
                }
                Spacer()
                if team.pokemon.count < Team.maximumPokemon {
                    // If a new Pokemon can be added, this will redirect to the page with a Pokemon finder.
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

    // Callback to delete Pokemon when swiped in the main list body.
    func deletePokemon(at offsets: IndexSet) {
        team.pokemon.remove(atOffsets: offsets)
    }
}

// This represents a single Pokemon inside the team.
// Upfront, it will show a Pokemon's name, sprite, types and selected moveset.
struct TeamMemberView: View {
    @Binding var pokemon: Pokemon

    // Initialised with defaults since it is not passed in externally.
    @State var move1: String = ""
    @State var move2: String = ""
    @State var move3: String = ""
    @State var move4: String = ""

    var body: some View {
        HStack {
            // Firstly, on the left, show the sprite and the Pokemon name.
            VStack {
                AsyncImage(url: pokemon.baseData.sprite)
                    .padding()
                Text("\(pokemon.formatName())")
                    .foregroundColor(overallForegroundColour())
            }
            .padding(.trailing, -10)

            Spacer()

            // Then, on the right, show the typings and the moves selected.
            VStack {
                HStack {
                    Text("\(typeText(pos: 0, empty: "unknown"))")
                        .foregroundColor(overallForegroundColour())
                        .lineLimit(1)
                        .frame(width: 70)

                    Text("\(typeText(pos: 1, empty: ""))")
                        .foregroundColor(overallForegroundColour())
                        .lineLimit(1)
                        .frame(width: 70)
                }
                .padding()
                .padding(.bottom, -10)

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
            // When the view is first loaded, the Pokemon moves are
            // loaded to synchronise with the true data.
            move1 = moveText(pos: 0, empty: "None")
            move2 = moveText(pos: 1, empty: "None")
            move3 = moveText(pos: 2, empty: "None")
            move4 = moveText(pos: 3, empty: "None")
        }
    }

    // Convenience function to load the correct foreground colour for all text
    // in the LineupView, matching with its primary type background colour.
    func overallForegroundColour() -> Color {
        return pokemon.baseData.types[0].getForegroundColour()
    }

    // Utility functions for getting a neat expression for the Pokemon typing and move text.

    func typeText(pos: Int, empty: String) -> String {
        let types = pokemon.baseData.types
        if types.count > pos {
            let type = types[pos].name
            return type.capitalized
        } else {
            return empty
        }
    }

    func moveText(pos: Int, empty: String) -> String {
        let moves = pokemon.chosenMoves
        if moves.count > pos {
            return moves[pos].formatMove()
        } else {
            return empty
        }
    }
}
