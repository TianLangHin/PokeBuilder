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
                        NavigationLink(destination: PokemonView(pokemon: $pokemon, listMove: pokemon.baseData.moves)) { //Adding list_move as something that need to be passed
                            TeamMemberView(pokemon: $pokemon)
                        }
                        .listRowBackground(getBackground(type: pokemon.baseData.types[0]))
                    }
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
    
    //Find new color cuh
    func getBackground(type: PokemonType) -> Color {
        switch type.name {
        case "normal":
            return Color.gray
        case "fighting":
            return Color.brown
        case "flying":
            return Color.blue
        case "poison":
            return Color.purple
        case "ground":
            return Color.brown
        case "rock":
            return Color.black
        case "bug":
            return Color.green
        case "steel":
            return Color.gray
        case "ghost":
            return Color.black
        case "fire":
            return Color.red
        case "water":
            return Color.blue
        case "grass":
            return Color.green
        case "electric":
            return Color.yellow
        case "psychic":
            return Color.purple
        case "ice":
            return Color.blue
        case "dragon":
            return Color.blue
        case "dark":
            return Color.black
        case "fairy":
            return Color.pink
        default:
            return Color.gray
        }
    }
}



///Need to find a way to dynamically refresh each item in the list to make the move appear when clicking `back`
struct TeamMemberView: View {
    @Binding var pokemon: Pokemon
    
    ///This is to initially show the four moves of the pokemon (I can't leave it blank)
    @State var move1: String = ""
    @State var move2: String = ""
    @State var move3: String = ""
    @State var move4: String = ""
    
    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: pokemon.baseData.sprite)
                    .padding()
                Text("\(pokemon.format())")
            }
            VStack {
                HStack {
                    Text("\(typeDisplay(pos: 0, empty: "unknown"))")
                    Text("\(typeDisplay(pos: 1, empty: ""))")
                }
                .padding()
                Grid() {
                    GridRow {
                        Text("\(move1)")
                        Text("\(move2)")
                    }
                    GridRow {
                        Text("\(move3)")
                        Text("\(move4)")
                    }
                }
            }
        }
        .onAppear(){
            move1 = moveDisplay(pos: 0, empty: "None")
            move2 = moveDisplay(pos: 1, empty: "None")
            move3 = moveDisplay(pos: 2, empty: "None")
            move4 = moveDisplay(pos: 3, empty: "None")
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

    func moveDisplay(pos: Int, empty: String) -> String {
        let moves = pokemon.chosenMoves
        if moves.count > pos {
            return moves[pos].name
        } else {
            return empty
        }
    }
}
