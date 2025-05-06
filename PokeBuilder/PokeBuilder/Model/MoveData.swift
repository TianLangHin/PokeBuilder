//
//  MoveData.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 6/5/2025.
//

import SwiftUI

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
