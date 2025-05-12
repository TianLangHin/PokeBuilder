//
//  TeamInfo.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 12/5/2025.
//

// This struct is used to load Pokemon type interaction information
// directly from the PokeAPI data. The interactions are nested inside
// a JSON object accessed through the "damage_relations" key.
struct TypeInfo: Codable {
    let damageRelations: TypeRelations

    enum CodingKeys: String, CodingKey {
        case damageRelations = "damage_relations"
    }

    // This custom struct represents the keys of the inner JSON object
    // from which the type relationships are defined.
    struct TypeRelations: Codable {
        let doubleFrom: [PokemonType]
        let doubleTo: [PokemonType]
        let halfFrom: [PokemonType]
        let halfTo: [PokemonType]
        let immuneFrom: [PokemonType]
        let immuneTo: [PokemonType]

        enum CodingKeys: String, CodingKey {
            case doubleFrom = "double_damage_from"
            case doubleTo = "double_damage_to"
            case halfFrom = "half_damage_from"
            case halfTo = "half_damage_to"
            case immuneFrom = "no_damage_from"
            case immuneTo = "no_damage_to"
        }
    }

    // e.g. `t1Info.getDefensiveRelation(to: t2String) = .double`
    // means that type `t1` takes double damage from `t2`.
    func getDefensiveRelation(to typeName: String) -> Matchup {
        let doubleLookup = self.damageRelations.doubleFrom.firstIndex(where: {$0.name == typeName})
        let halfLookup = self.damageRelations.halfFrom.firstIndex(where: {$0.name == typeName})
        let immuneLookup = self.damageRelations.immuneFrom.firstIndex(where: {$0.name == typeName})

        if doubleLookup != nil {
            return .double
        } else if halfLookup != nil {
            return .half
        } else if immuneLookup != nil {
            return .immune
        } else {
            return .normal
        }
    }
}

// Here, we use a simple scoring system.
// Any form of resistance is good (+1) and any form of weakness is bad (-1).
// This includes double weaknesses and half resistances.
enum Matchup {
    case normal
    case double
    case half
    case immune

    func score() -> Int {
        switch self {
        case .normal:
            return 0
        case .double:
            return -1
        case .half, .immune:
            return 1
        }
    }
}
