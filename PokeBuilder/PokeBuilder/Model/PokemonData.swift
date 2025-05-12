//
//  PokemonData.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI

// This struct contains the base (uncustomisable) data relating to a Pokemon.
// These are retrieved from PokeAPI, and is designed specifically for interfacing with the API.
struct PokemonData: Decodable {
    let name: String
    let sprite: URL?
    let moves: [PokemonMove]
    let types: [PokemonType]
    let stats: [Int]

    // Specifying the coding keys allows custom loading of JSON data into an immediately usable format,
    // rather than having to progressively unwrap each struct on the fly.
    enum CodingKeys: String, CodingKey {
        case species = "species"
        case sprites = "sprites"
        case moves = "moves"
        case types = "types"
        case stats = "stats"
    }

    // The following reads data from a JSONDecoder that follows the structure
    // when calling the `https://pokeapi.co/api/v2/pokemon/{number}` endpoint.
    // For the values inside nested JSON objects, private custom structs are used.
    init(from decoder: Decoder) throws {
        // First, the `CodingKeys` used decodes the top-level JSON structure.
        let values = try decoder.container(keyedBy: CodingKeys.self)

        // The species name is retrieved by the nested `["species"]["name"]` key.
        // The custom struct `PokemonSpecies` is used to unwrap this level.
        let speciesData = try values.decode(PokemonSpecies.self, forKey: .species)
        self.name = speciesData.name

        // The sprite image URL is retrieved by the nested `["sprites"]["front_default"]` key.
        // The custom struct `SpriteData` is used to unwrap this level.
        let spriteData = try values.decode(SpriteData.self, forKey: .sprites)
        self.sprite = URL(string: spriteData.frontDefault)

        // The list of available moves to the Pokemon is an array of JSON objects
        // with a "move" key that holds a JSON object with a "name" and a "url" key.
        // The custom struct `PokemonMoveWrapper` handles this unwrapping,
        // and the inner `PokemonMove` struct is extracted and stored.
        let moveData = try values.decode(Array<PokemonMoveWrapper>.self, forKey: .moves)
        self.moves = moveData.map({ $0.move })

        // The list of the Pokemon's types is an array of JSON objects
        // with a "type" key that holds a JSON object with a "name" and a "url" key.
        // The custom struct `PokemonTypeWrapper` handles this unwrapping,
        // and the inner `PokemonType` struct is extracted and stored.
        let typeData = try values.decode(Array<PokemonTypeWrapper>.self, forKey: .types)
        self.types = typeData.map({ $0.type })

        // The list of the Pokemon's base stats is an array of JSON objects
        // with a "base_stat" key that holds an integer.
        // These integers are extracted and stored.
        let statData = try values.decode(Array<StatData>.self, forKey: .stats)
        self.stats = statData.map({ $0.baseStat })
    }

    private struct PokemonSpecies: Codable {
        let name: String
    }

    private struct SpriteData: Codable {
        let frontDefault: String

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }

    private struct PokemonMoveWrapper: Codable {
        let move: PokemonMove
    }

    private struct PokemonTypeWrapper: Codable {
        let type: PokemonType
    }

    private struct StatData: Codable {
        let baseStat: Int

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
        }
    }
}
