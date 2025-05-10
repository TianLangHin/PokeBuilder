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
                                .padding(5)
                                .background(
                                    (typeDisplay(pos: 0, empty: "").isEmpty) ?
                                    Color.clear :
                                    displayTypeBackground(type: typeDisplay(pos: 0, empty: ""))
                                )
                                .foregroundColor(
                                    (typeDisplay(pos: 0, empty: "").isEmpty) ?
                                    Color.clear :
                                    getTypeForeColor(type: typeDisplay(pos: 0, empty: ""))
                                )
                                .cornerRadius(10)
                                
                            
                            Text("\(typeDisplay(pos: 1, empty: ""))")
                                .padding((typeDisplay(pos: 1, empty: "").isEmpty) ? 0 : 5)
                                .background(
                                    (typeDisplay(pos: 1, empty: "").isEmpty) ?
                                    Color.clear :
                                    displayTypeBackground(type: typeDisplay(pos: 1, empty: ""))
                                )
                                .foregroundColor(
                                    (typeDisplay(pos: 1, empty: "").isEmpty) ?
                                    Color.clear :
                                    getTypeForeColor(type: typeDisplay(pos: 1, empty: ""))
                                )
                                .cornerRadius(10)
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
                                    Text("\(move.formatMove())").tag(move)
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
                                    Text("\(move.formatMove())").tag(move)
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
                                    Text("\(move.formatMove())").tag(move)
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
                        .foregroundColor(checkCurrentEV(stat: Int(total)))
                    Image(systemName: extraEVText(stat: Int(total)))
                        .renderingMode(.original)
                        .symbolEffect(.bounce.up.wholeSymbol, options: .repeating)
                        .foregroundStyle((extraEVText(stat: Int(total)) == "flame.fill") ? Color.orange : Color.yellow)
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
            let type = types[pos].name
            return type.capitalized
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
    
    
    func displayTypeBackground(type: String) -> Color {
        switch type {
        case "Normal":
            return Color(hex: 0xA8A77A)
        case "Fighting":
            return Color(hex: 0xC22E28)
        case "Flying":
            return Color(hex: 0xA98FF3)
        case "Poison":
            return Color(hex: 0xA33EA1)
        case "Ground":
            return Color(hex: 0xE2BF65)
        case "Rock":
            return Color(hex: 0xB6A136)
        case "Bug":
            return Color(hex: 0xA6B91A)
        case "Steel":
            return Color(hex: 0xB7B7CE)
        case "Ghost":
            return Color(hex: 0x735797)
        case "Fire":
            return Color(hex: 0xEE8130)
        case "Water":
            return Color(hex: 0x6390F0)
        case "Grass":
            return Color(hex: 0x7AC74C)
        case "Electric":
            return Color(hex: 0xF7D02C)
        case "Psychic":
            return Color(hex: 0xF95587)
        case "Ice":
            return Color(hex: 0x96D9D6)
        case "Dragon":
            return Color(hex: 0x6F35FC)
        case "Dark":
            return Color(hex: 0x705746)
        case "Fairy":
            return Color(hex: 0xD685AD)
        default:
            return Color.gray
        }
    }
    
    
    
    func getTypeForeColor(type: String) -> Color{
        switch type {
        case "Normal":
            return Color.white
        case "Fighting":
            return Color.white
        case "Flying":
            return Color.black
        case "Poison":
            return Color.white
        case "Ground":
            return Color.black
        case "Rock":
            return Color.white
        case "Bug":
            return Color.white
        case "Steel":
            return Color.black
        case "Ghost":
            return Color.white
        case "Fire":
            return Color.black
        case "Water":
            return Color.black
        case "Grass":
            return Color.black
        case "Electric":
            return Color.black
        case "Psychic":
            return Color.white
        case "Ice":
            return Color.black
        case "Dragon":
            return Color.white
        case "Dark":
            return Color.white
        case "Fairy":
            return Color.black
        default:
            return Color.black
        }
    }
    
    func checkCurrentEV(stat: Int) -> Color {
        if stat <=  200 {
            return Color.green
        } else if stat <= 400 {
            return Color.orange
        } else {
            return Color(hex: 0xF1B502)
        }
    }
    
    func extraEVText(stat: Int) -> String {
        if stat <=  200 {
            return "tree.fill"
        } else if stat <= 400 {
            return "flame.fill"
        } else {
            return "crown.fill"
        }
    }
}
