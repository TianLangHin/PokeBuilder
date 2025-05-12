//
//  PokemonView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI

struct PokemonView: View {

    // The main source of data being edited by this View.
    @Binding var pokemon: Pokemon

    // State regarding the 4 moves a Pokemon can learn.
    // These first four states are automatically populated upon loading.
    @State var selectMove1: PokemonMove?
    @State var selectMove2: PokemonMove?
    @State var selectMove3: PokemonMove?
    @State var selectMove4: PokemonMove?

    // This is the list of moves that the Pokemon has access to.
    // (To be passed in as an argument)
    @State var moveList: [PokemonMove]

    // These variables are used to store the six stats of a Pokemon
    // for easier retrieval and display in addition to the `pokemon`
    // being edited. These are needed as a wrapper since Sliders
    // only work with Doubles and not Ints.
    @State var hp: Double = 0.0
    @State var atk: Double = 0.0
    @State var def: Double = 0.0
    @State var spa: Double = 0.0
    @State var spd: Double = 0.0
    @State var spe: Double = 0.0

    // For syntax simplification of retrieving the total number of EVs allocated.
    var statTotal: Int {
        pokemon.statSpread.currentTotal()
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                // Firstly, display the Pokemon sprite next to its name and typing.
                HStack {
                    AsyncImage(url: pokemon.baseData.sprite)
                    VStack {
                        Text("\(pokemon.formatName())")
                            .font(.title)
                        HStack {
                            typeDisplay(pos: 0)
                            typeDisplay(pos: 1)
                        }
                    }
                }

                // Below it, we show the actual stat points
                // (as a result of EV spread and base stats).
                Grid() {
                    GridRow {
                        Text("HP")
                        Text("Atk")
                        Text("Def")
                        Text("SpA")
                        Text("SpD")
                        Text("Spe")
                    }
                    GridRow {
                        Text("\(pokemon.actualStatPoint(stat: .hp))")
                        Text("\(pokemon.actualStatPoint(stat: .atk))")
                        Text("\(pokemon.actualStatPoint(stat: .def))")
                        Text("\(pokemon.actualStatPoint(stat: .spa))")
                        Text("\(pokemon.actualStatPoint(stat: .spd))")
                        Text("\(pokemon.actualStatPoint(stat: .spe))")
                    }
                }

                // Then, we provide a move selector for each of the four moves
                // the Pokemon can learn. The index conventions are from 1-4.
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

                // Below that is the count of the total EVs allocated to provide
                // an indicator of how much left we can allocate.
                HStack {
                    Text("Effort Values: ")
                        .font(.title3)
                    Text("\(statTotal)")
                        .font(.title3)
                        .foregroundColor(checkCurrentEV(stat: statTotal))
                    Image(systemName: extraEVText(stat: statTotal))
                        .renderingMode(.original)
                        .foregroundStyle(extraEVText(stat: statTotal) == "flame.fill" ? Color.orange : Color.yellow)
                }
                .padding()

                // We then provide sliders for allocating EVs to each of the six stats,
                // colour-coded according to the PokePaste colour palettes.
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
            // When initialised, a Pokemon move list will be empty.
            // We then initialise all four slots with a "None" placeholder if this is the case.
            if pokemon.chosenMoves.isEmpty {
                for _ in 0..<4 {
                    pokemon.chosenMoves.append(PokemonMove(name: "None", url: nil))
                }
            }
            // We then synchronise the states of each of the four move selections to the Pokemon data.
            selectMove1 = pokemon.chosenMoves[0]
            selectMove2 = pokemon.chosenMoves[1]
            selectMove3 = pokemon.chosenMoves[2]
            selectMove4 = pokemon.chosenMoves[3]
        }
    }

    // Convenience functions to programmatically retrieve and
    // edit the view's states relating to the Pokemon's stats.
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

    // Convenience function to create a View component to display one of a Pokemon's types.
    // Behaviour of the padding depends on whether this is the first (always existent) type
    // or the second (possibly non-existent) type.
    // The background and foreground colours are clear if it does not exist.
    func typeDisplay(pos: Int) -> some View {
        let type = getType(pos: pos)
        let bgColour = type?.getBackgroundColour() ?? Color.clear
        let fgColour = type?.getForegroundColour() ?? Color.clear

        return Text("\(typeText(pos: pos, empty: "unknown"))")
            .padding(pos == 0 ? 5 : getType(pos: 1) == nil ? 0 : 5)
            .background(bgColour)
            .foregroundColor(fgColour)
            .cornerRadius(10)
    }

    // Given a certain binding to a PokemonMove, its value, and which position in the array
    // it corresponds to, this function returns a View component that allows the user to select a move.
    func movePicker(pos: Int, binding: Binding<PokemonMove?>, value: PokemonMove?) -> some View {
        HStack {
            Text("Move \(pos):")
            Picker("Move \(pos)", selection: binding) {
                ForEach(moveList.sorted(), id: \.self) { move in
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
                    // To allow for the convention of using 1-4 instead of 0-3.
                    pokemon.chosenMoves[pos - 1] = selectedMove
                }
            }
        }
    }

    // Using the programmatic approach of getting a binding or a value (`getStat` and `setStat`),
    // this function returns a View component that provides the user a slider to allocate EVs
    // to a Pokemon's specific stat, which is also governed by the maximum allocation of 510 EVs.
    func statSlider(stat: Stat, binding: Binding<Double>, text: String, colour: Color) -> some View {
        VStack {
            Text("\(text): \(pokemon.statSpread.getStat(stat: stat))")
                .padding()
                .foregroundColor(colour)
            // A step of 4 is used here, since every 4 EV point is 1 stat point.
            // (This is domain-specific logic.)
            Slider(value: binding, in: 0...255, step: 4)
                .onChange(of: getStat(stat: stat)) { prevValue, newValue in
                    // Upon every change in the slider, a callback is made to ensure
                    // that the domain-specific invariant is upheld.
                    let newTotal = pokemon.statSpread.newTotal(change: stat, increment: Int(newValue))
                    if newTotal > StatSpread.maximumAllocation {
                        setStat(stat: stat, value: prevValue)
                    } else {
                        pokemon.statSpread.setStat(stat: stat, value: Int(newValue))
                    }
                }
                .onAppear(perform: {
                    // This is to synchronise the already allocated EVs upon loading an existing Pokemon.
                    setStat(stat: stat, value: Double(pokemon.statSpread.getStat(stat: stat)))
                })
        }
    }

    // Convenience function to get a Pokemon type at a certain array index,
    // returning `nil` if it does not exist.
    func getType(pos: Int) -> PokemonType? {
        let types = pokemon.baseData.types
        if types.count > pos {
            return types[pos]
        } else {
            return nil
        }
    }

    // Convenience function to get the text to display depending on if the Pokemon type exists.
    func typeText(pos: Int, empty: String) -> String {
        let type = getType(pos: pos)
        return type?.name.capitalized ?? empty
    }

    // Convenience function to return either the name of a Pokemon move or a placeholder.
    func moveText(pos: Int) -> String {
        let moves = pokemon.chosenMoves
        if moves.count > pos {
            return moves[pos].name
        } else {
            return "Move \(pos + 1)"
        }
    }

    // These next two functions are used to customise visual indicators of how much
    // progression has been made in allocating EVs.

    func checkCurrentEV(stat: Int) -> Color {
        if stat <= 200 {
            return Color.green
        } else if stat <= 400 {
            return Color.orange
        } else {
            return Color(hex: 0xF1B502)
        }
    }

    func extraEVText(stat: Int) -> String {
        if stat <= 200 {
            return "tree.fill"
        } else if stat <= 400 {
            return "flame.fill"
        } else {
            return "crown.fill"
        }
    }
}
