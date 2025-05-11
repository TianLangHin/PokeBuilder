//
//  PokemonMove.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 11/5/2025.
//

import SwiftUI

struct PokemonMove: Codable, Hashable, Comparable {
    let name: String
    let url: URL?
    
    func formatMove() -> String {
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
        
        if let newName = customNames[self.name] {
            return newName
        }
        else {
            return self.name.replacingOccurrences(of: "-", with: " ").capitalized
        }
    }

    static func < (lhs: PokemonMove, rhs: PokemonMove) -> Bool {
        return lhs.name < rhs.name
    }

    static func == (lhs: PokemonMove, rhs: PokemonMove) -> Bool {
        return lhs.name == rhs.name
    }
}
