//
//  MoveData.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 6/5/2025.
//

import SwiftUI

// This struct is used for directly reading Pokemon move data
// from the JSON returned by PokeAPI.
// It uses the inner `DamageClass` struct as well for storing whether
// it is a Physical, Special or Status move
// (which affects whether it is counting in offensive team coverage analysis).
struct MoveData: Codable {
    let type: PokemonType
    let damageClass: DamageClass

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case damageClass = "damage_class"
    }
}

struct DamageClass: Codable {
    let name: String
}
