//
//  PokemonView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI

struct PokemonView: View {

    @Binding var pokemon: Pokemon
    
    @State var selectMove1: PokemonMove?
    @State var selectMove2: PokemonMove?
    @State var selectMove3: PokemonMove?
    @State var selectMove4: PokemonMove?
    @State var listMove: [PokemonMove]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                HStack {
                    AsyncImage(url: pokemon.baseData.sprite)
                    VStack {
                        Text("\(pokemon.baseData.name)")
                            .font(.title)
                        HStack {
                            Text("\(typeDisplay(pos: 0, empty: "unknown"))")
                            Text("\(typeDisplay(pos: 1, empty: ""))")
                        }
                    }
                }
                Grid() {
                    GridRow {
                        // The first move picker
                        HStack{
                            Text("Move 1:")
                            Picker("Move 1", selection: $selectMove1){
                                ForEach(listMove, id: \.self) { move in
                                    Text("\(move.name)").tag(move)
                                }
                            }
                            .onChange(of: selectMove1){ oldValue, newMove in
                                guard let selectedMove = newMove else { return }
                                
                                if (pokemon.chosenMoves.isEmpty){
                                    pokemon.chosenMoves.append(selectedMove)
                                } else {
                                    pokemon.chosenMoves[0] = selectedMove
                                }
                            }
                        }
                        
                        Spacer()
                        
                        //The second move picker
                        HStack{
                            Text("Move 2:")
                            Picker("Move 2", selection: $selectMove2){
                                ForEach(listMove, id: \.self) { move in
                                    Text("\(move.name)").tag(move)
                                }
                            }
                            .onChange(of: selectMove2){ oldValue, newMove in
                                guard let selectedMove = newMove else { return }
                                
                                if !(pokemon.chosenMoves.count >= 2){
                                    pokemon.chosenMoves.append(selectedMove)
                                } else {
                                    pokemon.chosenMoves[1] = selectedMove
                                }
                            }
                        }
                        
                    }
                    GridRow {
                        //Picker for move 3
                        HStack{
                            Text("Move 3:")
                            Picker("Move 3", selection: $selectMove3){
                                ForEach(listMove, id: \.self) { move in
                                    Text("\(move.name)").tag(move)
                                }
                            }
                            .onChange(of: selectMove3){ oldValue, newMove in
                                guard let selectedMove = newMove else { return }
                                
                                if !(pokemon.chosenMoves.count >= 3){
                                    pokemon.chosenMoves.append(selectedMove)
                                } else {
                                    pokemon.chosenMoves[2] = selectedMove
                                }
                            }
                        }
                        
                        Spacer ()
                        
                        //Picker for move 4
                        HStack{
                            Text("Move 4:")
                            Picker("Move 4", selection: $selectMove4){
                                ForEach(listMove, id: \.self) { move in
                                    Text("\(move.name)").tag(move)
                                }
                            }
                            .onChange(of: selectMove4){ oldValue, newMove in
                                guard let selectedMove = newMove else { return }
                                
                                if !(pokemon.chosenMoves.count >= 4){
                                    pokemon.chosenMoves.append(selectedMove)
                                } else {
                                    pokemon.chosenMoves[3] = selectedMove
                                }
                            }
                        }
                    }
                
                }
                .padding()
                //This is for testing only
                Text("Move1: \(pokemon.chosenMoves.indices.contains(0) ? pokemon.chosenMoves[0].name : PokemonMove(name: "Select Move", url: nil).name)")
                Text("Move2: \(pokemon.chosenMoves.indices.contains(1) ? pokemon.chosenMoves[1].name : PokemonMove(name: "Select Move", url: nil).name)")
                Text("Move3: \(pokemon.chosenMoves.indices.contains(2) ? pokemon.chosenMoves[2].name : PokemonMove(name: "Select Move", url: nil).name)")
                Text("Move4: \(pokemon.chosenMoves.indices.contains(3) ? pokemon.chosenMoves[3].name : PokemonMove(name: "Select Move", url: nil).name)")
                
                Text("Effort Values:")
                    .font(.title3)
                    .padding()
                Grid() {
                    GridRow {
                        Text("HP: \(pokemon.statSpread.hitPoints)")
                            .padding()
                        Text("SpA: \(pokemon.statSpread.specialAttack)")
                            .padding()
                    }
                    GridRow {
                        Text("Atk: \(pokemon.statSpread.attack)")
                            .padding()
                        Text("SpD: \(pokemon.statSpread.specialDefense)")
                            .padding()
                    }
                    GridRow {
                        Text("Def: \(pokemon.statSpread.defense)")
                            .padding()
                        Text("Spe: \(pokemon.statSpread.speed)")
                            .padding()
                    }
                }
            }
        }
        //Initial value for the pokemon moves and the pokemon list:
        .onAppear(){
            listMove = pokemon.baseData.moves
            if pokemon.chosenMoves.isEmpty{
                for _ in 0..<4{
                    pokemon.chosenMoves.append(PokemonMove(name: "Select Move", url: nil))
                }
            }
            selectMove1 = pokemon.chosenMoves[0]
            selectMove2 = pokemon.chosenMoves[1]
            selectMove3 = pokemon.chosenMoves[2]
            selectMove4 = pokemon.chosenMoves[3]
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
            return "Move \(pos + 1)"
        }
    }
}
