//
//  PokemonData.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI
// PokemonData(name: "hello", sprite: nil, moves: [], types: [], stats: [])
struct PokemonData: Decodable {
    let name: String
    let sprite: URL?
    let moves: [PokemonMove]
    let types: [PokemonType]
    let stats: [Int]

    enum CodingKeys: String, CodingKey {
        case species = "species"
        case sprites = "sprites"
        case moves = "moves"
        case types = "types"
        case stats = "stats"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let speciesData = try values.decode(PokemonSpecies.self, forKey: .species)
        self.name = speciesData.name

        let spriteData = try values.decode(SpriteData.self, forKey: .sprites)
        self.sprite = URL(string: spriteData.frontDefault)

        let moveData = try values.decode(Array<PokemonMoveWrapper>.self, forKey: .moves)
        self.moves = moveData.map({ $0.move })

        let typeData = try values.decode(Array<PokemonTypeWrapper>.self, forKey: .types)
        self.types = typeData.map({ $0.type })

        let statData = try values.decode(Array<StatData>.self, forKey: .stats)
        self.stats = statData.map({ $0.baseStat })
    }
    
    private struct SpriteData: Codable {
        let frontDefault: String
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }

    private struct StatData: Codable {
        let baseStat: Int

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
        }
    }
}

private struct PokemonSpecies: Codable {
    let name: String
}

private struct PokemonMoveWrapper: Codable {
    let move: PokemonMove
}

struct PokemonMove: Codable, Hashable, Comparable { //Adding hashable for testing first
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

private struct PokemonTypeWrapper: Codable {
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
    let url: URL?
}
