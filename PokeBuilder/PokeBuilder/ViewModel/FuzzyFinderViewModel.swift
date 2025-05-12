//
//  FuzzyFinderViewModel.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 5/5/2025.
//

import SwiftUI

// This ViewModel handles the logic of conducting fuzzy-finding from a user to search
// for a particular Pokemon.
class FuzzyFinderViewModel: ObservableObject, Observable {

    @Published var pokemonNames: [String]

    init() {
        // Upon initialisation, reads the `names.txt` files for all Pokemon name data
        // instead of having to manually paginate through PokeAPI (very slow upon startup).
        self.pokemonNames = []
        // If, however, the resource is unavailable, nothing can be loaded.
        guard let path = Bundle.main.path(forResource: "names", ofType: "txt") else {
            return
        }
        guard let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
            return
        }
        self.pokemonNames = data.components(separatedBy: "\n")
    }

    // To get the corresponding number by which to query PokeAPI for a particular Pokemon,
    // we get the Pokemon name's position within the `pokemonNames` array.
    func apiNumber(name: String) -> Int? {
        guard let arrayIndex = self.pokemonNames.firstIndex(of: name) else {
            return nil
        }
        return arrayIndex + 1
    }

    // For displaying a List that changes dynamically.
    func filterOnSubstring(query: String) -> [String] {
        // Returns the list of Pokemon names that have the query string as a substring
        // (which does not have to be contiguous).
        let query = query.lowercased()
        if query.trimmingCharacters(in: .whitespaces) == "" {
            return pokemonNames
        }
        return pokemonNames.filter({
            isSubSequence(sub: query, larger: Pokemon.formatName(pokemonName: $0).lowercased())
        })
    }

    // Utility function to determine whether one string is a substring of another.
    // This is the main functionality to determine which Pokemon to show in a search query.
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
