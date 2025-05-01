//
//  ItemApiData.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI

struct ItemApiData: Codable, Identifiable {

    let id = UUID()

    let name: String
    let sprite: URL?
    let effect: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case sprite = "sprites"
        case effect = "effect_entries"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try values.decode(String.self, forKey: .name)

        let sprite = try values.decode(ItemSprite.self, forKey: .sprite)
        self.sprite = URL(string: sprite.sprite)

        let effectEntries = try values.decode(Array<ItemEffect>.self, forKey: .effect)
        self.effect = effectEntries[0].shortEffect
    }
}

struct ItemEffect: Codable {
    let shortEffect: String

    enum CodingKeys: String, CodingKey {
        case shortEffect = "short_effect"
    }
}

struct ItemSprite: Codable {
    let sprite: String

    enum CodingKeys: String, CodingKey {
        case sprite = "default"
    }
}
