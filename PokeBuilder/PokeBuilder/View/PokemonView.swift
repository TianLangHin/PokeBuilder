//
//  PokemonView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI

struct PokemonView: View {

    @Binding var pokemon: Pokemon

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
                        Text("\(moveDisplay(pos: 0))")
                        Text("\(moveDisplay(pos: 1))")
                    }
                    GridRow {
                        Text("\(moveDisplay(pos: 2))")
                        Text("\(moveDisplay(pos: 3))")
                    }
                }
                .padding()
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
