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
    
    var total: Double {
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
                            typeText(pos: 0)
                                .padding(5)
                            typeText(pos: 1)
                                .padding((typeDisplay(pos: 1, empty: "").isEmpty) ? 0 : 5)
                        }
                    }
                }
                Grid() {
                    GridRow {
                        movePicker(pos: 1, binding: $selectMove1, value: selectMove1)
                        Spacer()
                        movePicker(pos: 2, binding: $selectMove2, value: selectMove2)
                    }
                    GridRow {
                        movePicker(pos: 3, binding: $selectMove3, value: selectMove3)
                        Spacer ()
                        movePicker(pos: 4, binding: $selectMove4, value: selectMove4)
                    }
                }
                .padding()

                HStack {
                    Text("Effort Values: ")
                        .font(.title3)
                    Text("\(Int(total))")
                        .font(.title3)
                        .foregroundColor(checkCurrentEV(stat: Int(total)))
                    Image(systemName: extraEVText(stat: Int(total)))
                        .renderingMode(.original)
                        .foregroundStyle((extraEVText(stat: Int(total)) == "flame.fill") ? Color.orange : Color.yellow)
                }
                .padding()

                Grid() {
                    GridRow {
                        statSlider(stat: .hp, binding: $hp, text: "HP", colour: Color(hex: 0xFF0000))
                        statSlider(stat: .spa, binding: $spa, text: "SpA", colour: Color(hex: 0x6890F0))
                    }
                    GridRow {
                        statSlider(stat: .atk, binding: $atk, text: "Atk", colour: Color(hex: 0xF08030))
                        statSlider(stat: .spd, binding: $spd, text: "SpD", colour: Color(hex: 0x78C850))
                    }
                    GridRow {
                        statSlider(stat: .def, binding: $def, text: "Def", colour: Color(hex: 0xF8D030))
                        statSlider(stat: .spe, binding: $spe, text: "Spe", colour: Color(hex: 0xF85888))
                    }
                }
            }
        }
        .onAppear() {
            // Initial value for the pokemon moves and the pokemon list:
            if pokemon.chosenMoves.isEmpty {
                for _ in 0..<4 {
                    pokemon.chosenMoves.append(PokemonMove(name: "None", url: nil))
                }
            }
            selectMove1 = pokemon.chosenMoves[0]
            selectMove2 = pokemon.chosenMoves[1]
            selectMove3 = pokemon.chosenMoves[2]
            selectMove4 = pokemon.chosenMoves[3]
        }
    }

    func typeText(pos: Int) -> some View {
        Text("\(typeDisplay(pos: pos, empty: "unknown"))")
            .background(
                (typeDisplay(pos: pos, empty: "").isEmpty)
                    ? Color.clear
                    : displayTypeBackground(type: typeDisplay(pos: pos, empty: ""))
            )
            .foregroundColor(
                (typeDisplay(pos: pos, empty: "").isEmpty)
                    ? Color.clear
                    : getTypeForecolour(type: typeDisplay(pos: pos, empty: ""))
            )
            .cornerRadius(10)
    }

    func movePicker(pos: Int, binding: Binding<PokemonMove?>, value: PokemonMove?) -> some View {
        HStack {
            Text("Move \(pos):")
            Picker("Move \(pos)", selection: binding){
                ForEach(listMove.sorted(), id: \.self) { move in
                    Text("\(move.formatMove())").tag(move)
                }
            }
            .onChange(of: value) { oldValue, newMove in
                guard let selectedMove = newMove else {
                    return
                }
                if pokemon.chosenMoves.count < pos {
                    pokemon.chosenMoves.append(selectedMove)
                } else {
                    pokemon.chosenMoves[pos - 1] = selectedMove
                }
            }
        }
    }

    func getStat(stat: Stat) -> Double {
        switch stat {
        case .hp:
            hp
        case .atk:
            atk
        case .def:
            def
        case .spa:
            spa
        case .spd:
            spd
        case .spe:
            spe
        }
    }

    func setStat(stat: Stat, value: Double) {
        switch stat {
        case .hp:
            hp = value
        case .atk:
            atk = value
        case .def:
            def = value
        case .spa:
            spa = value
        case .spd:
            spd = value
        case .spe:
            spe = value
        }
    }

    func statSlider(stat: Stat, binding: Binding<Double>, text: String, colour: Color) -> some View {
        let statChange = getStat(stat: stat)
        return VStack {
            Text("\(text): \(pokemon.statSpread.getStat(stat: stat))")
                .padding()
                .foregroundColor(colour)
            Slider(value: binding, in: 0...255, step: 4)
                .onChange(of: statChange) { prevValue, newValue in
                    let newTotal = pokemon.statSpread.newTotal(change: stat, increment: Int(newValue))
                    if newTotal > StatSpread.maximumAllocation {
                        setStat(stat: stat, value: prevValue)
                    } else {
                        pokemon.statSpread.setStat(stat: stat, value: Int(newValue))
                    }
                }
                .onAppear(perform: {
                    setStat(stat: stat, value: Double(pokemon.statSpread.getStat(stat: stat)))
                })
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

    func getTypeForecolour(type: String) -> Color {
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
