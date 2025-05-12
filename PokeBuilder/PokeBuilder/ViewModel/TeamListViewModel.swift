//
//  TeamListViewModel.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 29/4/2025.
//

import SwiftUI

// This ViewModel manages the list of teams that a user will have in the app.
class TeamListViewModel: ObservableObject, Observable {
    @Published var userTeams: [Team] = []

    func addTeam(name: String) {
        let newTeam = Team(name: name)
        userTeams.append(newTeam)
    }

    // Used for determining whether a new team of a certain name can be made,
    // since duplicates are disallowed.
    func duplicateCheck(name: String) -> Bool {
        return userTeams.map({$0.name}).contains(name)
    }

    func deleteTeam(at offsets: IndexSet) {
        userTeams.remove(atOffsets: offsets)
    }
}
