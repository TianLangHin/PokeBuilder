//
//  PokemonApiData.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

// Needs to have: `name`, `abilities`, `moves`, `stats`
/*
 name: String
 abilities: [String]
 moves: [String]
 stats: [Int]
 */

import SwiftUI

struct PokemonApiData: Codable, Identifiable {
    let id = UUID()

    let name: String
    let abilities: [URL?]
    let moves: [URL?]
    let stats: [Int]
    let sprite: URL?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case abilities = "abilities"
        case moves = "moves"
        case stats = "stats"
        case sprite = "sprites"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)

        let abilityList = try values.decode(Array<PokemonAbility>.self, forKey: .abilities)
        self.abilities = abilityList.map({ URL(string: $0.ability.url) })

        let moveList = try values.decode(Array<PokemonMove>.self, forKey: .moves)
        self.moves = moveList.map({ URL(string: $0.move.url) })

        let statList = try values.decode(Array<PokemonStat>.self, forKey: .stats)
        self.stats = statList.map({ $0.baseStat })

        let sprite = try values.decode(PokemonSprite.self, forKey: .sprite)
        self.sprite = URL(string: sprite.frontDefault)
    }
}

private struct PokemonAbility: Codable {
    let ability: PokemonAbilityUrl

    enum CodingKeys: String, CodingKey {
        case ability = "ability"
    }

    struct PokemonAbilityUrl: Codable {
        let url: String
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.ability = try values.decode(PokemonAbilityUrl.self, forKey: .ability)
    }
}

private struct PokemonMove: Codable {
    let move: PokemonMoveUrl
    
    enum CodingKeys: String, CodingKey {
        case move = "move"
    }
    
    struct PokemonMoveUrl: Codable {
        let url: String
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.move = try values.decode(PokemonMoveUrl.self, forKey: .move)
    }
}

private struct PokemonStat: Codable {

    let baseStat: Int

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
    }
}

private struct PokemonSprite: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
