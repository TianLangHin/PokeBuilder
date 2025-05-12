//
//  PokemonMove.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 11/5/2025.
//

import SwiftUI

struct PokemonMove: Codable, Hashable, Comparable {
    // The `name` is used for displaying the move,
    // while the `url` is used to retrieve offensive type matchup data from PokeAPI.
    let name: String
    let url: URL?

    // Function to convert the `kebab-case` API format into a readable format
    // with domain-specific logic.
    func formatMove() -> String {
        // These are explicitly-coded exceptions to any particular rule,
        // which are guaranteed not to change in Pokemon terminology.
        let customNames = [
            "lands-wrath": "Land's Wrath",
            "baby-doll-eyes": "Baby-Doll Eyes",
            "forests-curse": "Forest's Curse",
            "freeze-dry": "Freeze-Dry",
            "lock-on": "Lock-On",
            "mud-slap": "Mud-Slap",
            "multi-attack": "Multi-Attack",
            "natures-madness": "Nature's Madness",
            "power-up-punch": "Power-Up Punch",
            "self-destruct": "Self-Destruct",
            "trick-or-treat": "Trick-Or-Treat",
            "u-turn": "U-Turn",
            "v-create": "V-Create",
            "wake-up-slap": "Wake-Up Slap",
            "will-o-wisp": "Will-O-Wisp",
            "x-scissor": "X-Scissor"
        ]

        // If the relevant move is one of the exceptions to the conventional rule,
        // we use the above lookup table.
        if let newName = customNames[self.name] {
            return newName
        } else {
            // Otherwise, remove all hyphens and capitalise each word.
            return self.name.replacingOccurrences(of: "-", with: " ").capitalized
        }
    }

    // These functions implement an ordering of the moves to allow use in a picker.
    static func < (lhs: PokemonMove, rhs: PokemonMove) -> Bool {
        return lhs.name < rhs.name
    }

    static func == (lhs: PokemonMove, rhs: PokemonMove) -> Bool {
        return lhs.name == rhs.name
    }
}
