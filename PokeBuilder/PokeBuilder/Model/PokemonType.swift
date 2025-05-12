//
//  PokemonType.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 12/5/2025.
//

import SwiftUI

struct PokemonType: Codable {
    // The `name` is most used for display,
    // while the `url` is used to query PokeAPI for type interactions.
    let name: String
    let url: URL?

    // Colours for each Pokemon type, inspiration of which is taken from
    // https://gist.github.com/apaleslimghost/0d25ec801ca4fc43317bcff298af43c3
    func getBackgroundColour() -> Color {
        switch self.name {
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

    // Colours for the foreground text when put against the above background color,
    // designed to maximise contrast with the background colour.
    func getForegroundColour() -> Color {
        switch self.name {
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
