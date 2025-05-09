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
                        .listRowBackground(getBackground(type: pokemon.baseData.types[0]))
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
    
    
    
    //https://gist.github.com/apaleslimghost/0d25ec801ca4fc43317bcff298af43c3
    func getBackground(type: PokemonType) -> Color {
        switch type.name {
        case "normal":
            return Color(hex: 0xA8A77A)
        case "fighting":
            return Color(hex: 0xC22E28)
        case "flying":
            return Color(hex: 0xA98FF3)
        case "poison":
            return Color(hex: 0xA33EA1)
        case "ground":
            return Color(hex: 0xE2BF65)
        case "rock":
            return Color(hex: 0xB6A136)
        case "bug":
            return Color(hex: 0xA6B91A)
        case "steel":
            return Color(hex: 0xB7B7CE)
        case "ghost":
            return Color(hex: 0x735797)
        case "fire":
            return Color(hex: 0xEE8130)
        case "water":
            return Color(hex: 0x6390F0)
        case "grass":
            return Color(hex: 0x7AC74C)
        case "electric":
            return Color(hex: 0xF7D02C)
        case "psychic":
            return Color(hex: 0xF95587)
        case "ice":
            return Color(hex: 0x96D9D6)
        case "dragon":
            return Color(hex: 0x6F35FC)
        case "dark":
            return Color(hex: 0x705746)
        case "fairy":
            return Color(hex: 0xD685AD)
        default:
            return Color.gray
        }
    }
    
    
    
    // Function to delete pokemon
    func deletePokemon(at offsets: IndexSet) {
        team.pokemon.remove(atOffsets: offsets)
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
                Text("\(pokemon.formatName())")
                    .foregroundColor((getListForeColor(type: pokemon.baseData.types[0])))
            }
            .padding(.trailing, -10)
            
            Spacer()
            
            VStack {
                HStack {
                    Text("\(typeDisplay(pos: 0, empty: "unknown"))")
                        .foregroundColor((getListForeColor(type: pokemon.baseData.types[0])))
                        .lineLimit(1)
                        .frame(width: 60)
                    
                    Text("\(typeDisplay(pos: 1, empty: ""))")
                        .foregroundColor((getListForeColor(type: pokemon.baseData.types[0])))
                        .lineLimit(1)
                        .frame(width: 60)
                        
                }
                .padding()
                Grid() {
                    GridRow {
                        Text("\(move1)")
                            .foregroundColor((getListForeColor(type: pokemon.baseData.types[0])))
                            .frame(width: 60)
                        
                        Text("\(move2)")
                            .foregroundColor((getListForeColor(type: pokemon.baseData.types[0])))
                            .frame(width: 60)
                    }
                    GridRow {
                        Text("\(move3)")
                            .foregroundColor((getListForeColor(type: pokemon.baseData.types[0])))
                            .frame(width: 60)
                        
                        Text("\(move4)")
                            .foregroundColor((getListForeColor(type: pokemon.baseData.types[0])))
                            .frame(width: 60)
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
    
    
    func getListForeColor(type: PokemonType) -> Color{
        switch type.name {
        case "normal":
            return Color.white
        case "fighting":
            return Color.white
        case "flying":
            return Color.black
        case "poison":
            return Color.white
        case "ground":
            return Color.black
        case "rock":
            return Color.white
        case "bug":
            return Color.white
        case "steel":
            return Color.black
        case "ghost":
            return Color.white
        case "fire":
            return Color.black
        case "water":
            return Color.black
        case "grass":
            return Color.black
        case "electric":
            return Color.black
        case "psychic":
            return Color.white
        case "ice":
            return Color.black
        case "dragon":
            return Color.white
        case "dark":
            return Color.white
        case "fairy":
            return Color.black
        default:
            return Color.black
        }
    }
}
