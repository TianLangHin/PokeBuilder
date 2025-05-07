//
//  FuzzyFinderViewModel.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 5/5/2025.
//

import SwiftUI

class FuzzyFinderViewModel: ObservableObject, Observable {
    @Published var pokemonNames: [String]

    init() {
        self.pokemonNames = []
        guard let path = Bundle.main.path(forResource: "names", ofType: "txt") else {
            return
        }
        guard let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
            return
        }
        self.pokemonNames = data.components(separatedBy: "\n")
    }

    func apiNumber(name: String) -> Int? {
        guard let arrayIndex = self.pokemonNames.firstIndex(of: name) else {
            return nil
        }
        return arrayIndex + 1
    }

    // For displaying a List that changes dynamically.
    func filterOnSubstring(query: String) -> [String] {
        // Will potentially need normalisation here and account for
        // difference between API format and human-readable format.
        let query = query.lowercased()
        if query.trimmingCharacters(in: .whitespaces) == "" {
            return pokemonNames
        }
        return pokemonNames.filter({
            isSubSequence(sub: query, larger: Pokemon.format(pokemonName: $0).lowercased())
        })
    }

    private func isSubSequence(sub: String, larger: String) -> Bool {
        let subLength = sub.count
        let largerLength = larger.count
        let subStart = sub.startIndex
        let largerStart = larger.startIndex
        var i = 0
        var j = 0
        while i < subLength && j < largerLength {
            let charAtSub = sub.index(subStart, offsetBy: i)
            let charAtLarger = larger.index(largerStart, offsetBy: j)
            if sub[charAtSub] == larger[charAtLarger] {
                i += 1
            }
            j += 1
        }
        return i == subLength
    }
}
