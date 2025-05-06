//
//  PokemonData.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI
// PokemonData(name: "hello", sprite: nil, moves: [], types: [], stats: [])
struct PokemonData: Codable {
    let name: String
    let sprite: URL?
    let moves: [PokemonMove]
    let types: [PokemonType]
    let stats: [Int]

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case sprite = "sprites"
        case moves = "moves"
        case types = "types"
        case stats = "stats"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try values.decode(String.self, forKey: .name)

        let spriteData = try values.decode(SpriteData.self, forKey: .sprite)
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

private struct PokemonMoveWrapper: Codable {
    let move: PokemonMove
}

struct PokemonMove: Codable, Hashable { //Adding hashable for testing first
    let name: String
    let url: URL?
}

private struct PokemonTypeWrapper: Codable {
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
    let url: URL?
}
