//
//  TeamAnalysisViewModel.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 6/5/2025.
//

import SwiftUI

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

struct TypeInfo: Codable {
    let damageRelations: TypeRelations
    
    enum CodingKeys: String, CodingKey {
        case damageRelations = "damage_relations"
    }
    
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

class TeamAnalysisViewModel: ObservableObject, Observable {
    static let typeNames = [
        "normal", "fighting", "flying", "poison", "ground", "rock",
        "bug", "steel", "ghost", "fire", "water", "grass",
        "electric", "psychic", "ice", "dragon", "dark", "fairy"
    ]

    private var hasPrepared = false
    var typeMatchups: [String: TypeInfo] = [:]

    let jsonDecoder = JSONDecoder()

    func prepareTable() async {
        if !hasPrepared {
            for typeName in TeamAnalysisViewModel.typeNames {
                let url = URL(string: "https://pokeapi.co/api/v2/type/\(typeName)")!
                guard let (data, _) = try? await URLSession.shared.data(from: url) else {
                    continue
                }
                guard let typeInfo = try? jsonDecoder.decode(TypeInfo.self, from: data) else {
                    continue
                }
                self.typeMatchups[typeName] = typeInfo
            }
            hasPrepared = true
        }
    }

    func defensiveCoverage(team: Team) -> [String: Int] {
        var teamDefense: [String: Int] = [:]
        for typeName in TeamAnalysisViewModel.typeNames {
            var totalTypeScore = 0
            for pokemon in team.pokemon {
                var score = 0
                for type in pokemon.baseData.types {
                    let relation = typeMatchups[type.name]?.getDefensiveRelation(to: typeName)
                    switch relation {
                    case .immune:
                        score = 1
                        break
                    default:
                        score += relation?.score() ?? 0
                    }
                }
                if score >= 1 {
                    score = 1
                } else if score <= -1 {
                    score = -1
                }
                totalTypeScore += score
            }
            teamDefense[typeName] = totalTypeScore
        }
        return teamDefense
    }

    func offensiveCoverage(team: Team) async -> [String: Int] {
        var teamOffense: [String: Int] = [:]
        for typeName in TeamAnalysisViewModel.typeNames {
            teamOffense[typeName] = 0
            for pokemon in team.pokemon {
                for move in pokemon.chosenMoves {
                    guard let url = move.url else {
                        continue
                    }
                    guard let (data, _) = try? await URLSession.shared.data(from: url) else {
                        continue
                    }
                    guard let moveData = try? jsonDecoder.decode(MoveData.self, from: data) else {
                        continue
                    }
                    guard moveData.damageClass.name != "status" else {
                        continue
                    }
                    let relation = typeMatchups[typeName]?.getDefensiveRelation(to: moveData.type.name)
                    let score = switch relation {
                    case .normal, nil:
                        0
                    case .half, .immune:
                        -1
                    case .double:
                        1
                    }
                    teamOffense[typeName] = (teamOffense[typeName] ?? 0) + score
                }
            }
        }
        return teamOffense
    }
}
