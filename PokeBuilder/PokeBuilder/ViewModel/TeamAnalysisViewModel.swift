//
//  TeamAnalysisViewModel.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 6/5/2025.
//

import SwiftUI

class TeamAnalysisViewModel: ObservableObject, Observable {
    // Hard-coded here since this type-chart has not changed since 2013,
    // and to avoid unnecessary API pagination to search for all possible types.
    static let typeNames = [
        "normal", "fighting", "flying", "poison", "ground", "rock",
        "bug", "steel", "ghost", "fire", "water", "grass",
        "electric", "psychic", "ice", "dragon", "dark", "fairy"
    ]

    // Since loading type matchups requires PokeAPI calls, we need a state to track
    // whether the async task has been concluded or not.
    // The type matchups are also stored in a dictionary which is initially empty.
    private var hasPrepared = false
    var typeMatchups: [String: TypeInfo] = [:]

    let jsonDecoder = JSONDecoder()

    // This is to be executed before any other analysis is made.
    // It is made separate from a custom initialiser since this must be triggered
    // upon appearance of `AnalysisView`.
    func prepareTable() async {
        // We only start the queries if we are not already initialised.
        if !hasPrepared {
            for typeName in TeamAnalysisViewModel.typeNames {
                // If somehow an API call fails, we do not crash the app.
                // We instead ensure the rest of the functionality can still be used somewhat.
                let url = URL(string: "https://pokeapi.co/api/v2/type/\(typeName)")!
                guard let (data, _) = try? await URLSession.shared.data(from: url) else {
                    continue
                }
                // We also use a custom `TypeInfo` struct to encode all the type interactions.
                guard let typeInfo = try? jsonDecoder.decode(TypeInfo.self, from: data) else {
                    continue
                }
                self.typeMatchups[typeName] = typeInfo
            }
            hasPrepared = true
        }
    }

    // Since the names of each Pokemon type is stored as-is (as Strings),
    // once the table is prepared we can immediately calculate all defensive coverage.
    func defensiveCoverage(team: Team) -> [String: Int] {
        var teamDefense: [String: Int] = [:]
        // We iterate over every type.
        for typeName in TeamAnalysisViewModel.typeNames {
            var totalTypeScore = 0
            // We then check the number of times a Pokemon has a typing that
            // interacts with the current type being considered.
            for pokemon in team.pokemon {
                var score = 0
                // We consider each of the types,
                // incrementing the score if a resistance is found,
                // and decrementing the score if a weakness is found.
                for type in pokemon.baseData.types {
                    // If a type matchup combination does not exist in the table,
                    // then it is a neutral interaction.
                    let relation = typeMatchups[type.name]?.getDefensiveRelation(to: typeName)
                    // However, if an immunity is found, ignore all other typings,
                    // since this is definitely a positive matchup.
                    switch relation {
                    case .immune:
                        score = 1
                        break
                    default:
                        score += relation?.score() ?? 0
                    }
                }
                // We then correct double weaknesses and double resistances
                // down to a score of magnitude 1.
                if score >= 1 {
                    score = 1
                } else if score <= -1 {
                    score = -1
                }
                // We add this to the overall team score against the current type.
                totalTypeScore += score
            }
            teamDefense[typeName] = totalTypeScore
        }
        return teamDefense
    }

    // Since the types of moves are instead accessed via a URL accompanying the move name,
    // we make this function async since it calls the PokeAPI repeatedly to get each move type
    // and construct the offensive coverage table.
    func offensiveCoverage(team: Team) async -> [String: Int] {
        var teamOffense: [String: Int] = [:]
        for typeName in TeamAnalysisViewModel.typeNames {
            teamOffense[typeName] = 0
            for pokemon in team.pokemon {
                for move in pokemon.chosenMoves {
                    // If any of the PokeAPI queries fail, once again,
                    // we smooth over it by continuing to the next iteration
                    // to prioritise user experience.
                    guard let url = move.url else {
                        continue
                    }
                    guard let (data, _) = try? await URLSession.shared.data(from: url) else {
                        continue
                    }
                    guard let moveData = try? jsonDecoder.decode(MoveData.self, from: data) else {
                        continue
                    }
                    // We also ignore any moves that are status moves,
                    // since they do not contribute to type coverage.
                    guard moveData.damageClass.name != "status" else {
                        continue
                    }
                    // If a type matchup combination does not exist in the table,
                    // then it is a neutral interaction.
                    let relation = typeMatchups[typeName]?.getDefensiveRelation(to: moveData.type.name)
                    // We invert the logic here, since it is now "good" if we target a weakness.
                    let score = switch relation {
                    case .normal, nil:
                        0
                    case .half, .immune:
                        -1
                    case .double:
                        1
                    }
                    // We update the score for the particular type here.
                    teamOffense[typeName] = (teamOffense[typeName] ?? 0) + score
                }
            }
        }
        return teamOffense
    }
}
