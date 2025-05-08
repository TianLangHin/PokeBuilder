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

    @State var hp: Double = 0.0
    @State var atk: Double = 0.0
    @State var def: Double = 0.0
    @State var spa: Double = 0.0
    @State var spd: Double = 0.0
    @State var spe: Double = 0.0
    
    var total: Double{
        hp + atk + def + spa + spd + spe
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                HStack {
                    AsyncImage(url: pokemon.baseData.sprite)
                    VStack {
                        Text("\(pokemon.formatName())")
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
                                ForEach(listMove.sorted(), id: \.self) { move in
                                    Text("\(move.formatMove(name))").tag(move)
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
                                ForEach(listMove.sorted(), id: \.self) { move in
                                    Text("\(move.formatMove(name))").tag(move)
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
                                ForEach(listMove.sorted(), id: \.self) { move in
                                    Text("\(move.formatMove(name))").tag(move)
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
                                ForEach(listMove.sorted(), id: \.self) { move in
                                    Text("\(move.formatMove())").tag(move)
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
                
                HStack{
                    Text("Effort Values: ")
                        .font(.title3)
                    Text("\(Int(total))")
                        .font(.title3)
                        .foregroundStyle((Int(total) > 500) ? Color.red : Color.black)
                }
                .padding()
                
                Grid() {
                    GridRow {
                        VStack {
                            // Stat colour palette obtained from PokePaste
                            Text("HP: \(pokemon.statSpread.hitPoints)")
                                .padding()
                                .foregroundColor(Color(hex: 0xFF0000))
                            Slider(value: $hp, in: 0...255, step: 4)
                                .onChange(of: hp) { prevValue, newValue in
                                    let newTotal = pokemon.statSpread.newTotal(change: .hp(Int(newValue)))
                                    if newTotal > StatSpread.maximumAllocation {
                                        hp = prevValue
                                    } else {
                                        pokemon.statSpread.hitPoints = Int(newValue)
                                    }
                                }
                                .onAppear(perform: {
                                    hp = Double(pokemon.statSpread.hitPoints)
                                })
                        }
                        VStack {
                            Text("SpA: \(pokemon.statSpread.specialAttack)")
                                .padding()
                                .foregroundColor(Color(hex: 0x6890F0))
                            Slider(value: $spa, in: 0...255, step: 4)
                                .onChange(of: spa) { prevValue, newValue in
                                    let newTotal = pokemon.statSpread.newTotal(change: .spa(Int(newValue)))
                                    if newTotal > StatSpread.maximumAllocation {
                                        spa = prevValue
                                    } else {
                                        pokemon.statSpread.specialAttack = Int(newValue)
                                    }
                                }
                                .onAppear(perform: {
                                    spa = Double(pokemon.statSpread.specialAttack)
                                })
                        }
                    }
                    GridRow {
                        VStack {
                            Text("Atk: \(pokemon.statSpread.attack)")
                                .padding()
                                .foregroundColor(Color(hex: 0xF08030))
                            Slider(value: $atk, in: 0...255, step: 4)
                                .onChange(of: atk) { prevValue, newValue in
                                    let newTotal = pokemon.statSpread.newTotal(change: .atk(Int(newValue)))
                                    if newTotal > StatSpread.maximumAllocation {
                                        atk = prevValue
                                    } else {
                                        pokemon.statSpread.attack = Int(newValue)
                                    }
                                }
                                .onAppear(perform: {
                                    atk = Double(pokemon.statSpread.attack)
                                })
                        }
                        VStack {
                            Text("SpD: \(pokemon.statSpread.specialDefense)")
                                .padding()
                                .foregroundColor(Color(hex: 0x78C850))
                            Slider(value: $spd, in: 0...255, step: 4)
                                .onChange(of: spd) { prevValue, newValue in
                                    let newTotal = pokemon.statSpread.newTotal(change: .spd(Int(newValue)))
                                    if newTotal > StatSpread.maximumAllocation {
                                        spd = prevValue
                                    } else {
                                        pokemon.statSpread.specialDefense = Int(newValue)
                                    }
                                }
                                .onAppear(perform: {
                                    spd = Double(pokemon.statSpread.specialDefense)
                                })
                        }
                    }
                    GridRow {
                        VStack {
                            Text("Def: \(pokemon.statSpread.defense)")
                                .padding()
                                .foregroundColor(Color(hex: 0xF8D030))
                            Slider(value: $def, in: 0...255, step: 4)
                                .onChange(of: def) { prevValue, newValue in
                                    let newTotal = pokemon.statSpread.newTotal(change: .def(Int(newValue)))
                                    if newTotal > StatSpread.maximumAllocation {
                                        def = prevValue
                                    } else {
                                        pokemon.statSpread.defense = Int(newValue)
                                    }
                                }
                                .onAppear(perform: {
                                    def = Double(pokemon.statSpread.defense)
                                })
                        }
                        VStack {
                            Text("Spe: \(pokemon.statSpread.speed)")
                                .padding()
                                .foregroundColor(Color(hex: 0xF85888))
                            Slider(value: $spe, in: 0...255, step: 4)
                                .onChange(of: spe) { prevValue, newValue in
                                    let newTotal = pokemon.statSpread.newTotal(change: .spe(Int(newValue)))
                                    if newTotal > StatSpread.maximumAllocation {
                                        spe = prevValue
                                    } else {
                                        pokemon.statSpread.speed = Int(newValue)
                                    }
                                }
                                .onAppear(perform: {
                                    spe = Double(pokemon.statSpread.speed)
                                })
                        }
                    }
                }
            }
        }
        //Initial value for the pokemon moves and the pokemon list:
        .onAppear(){
            listMove = pokemon.baseData.moves
            if pokemon.chosenMoves.isEmpty{
                for _ in 0..<4{
                    pokemon.chosenMoves.append(PokemonMove(name: "None", url: nil))
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
