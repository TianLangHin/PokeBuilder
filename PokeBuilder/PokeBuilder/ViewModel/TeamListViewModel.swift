//
//  TeamListViewModel.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 29/4/2025.
//

import SwiftUI

class TeamListViewModel: ObservableObject, Observable {
    @Published var userTeams: [Team] = []
    
    func removeTeam(team: Team) {
        guard let index = userTeams.firstIndex(where: {$0.id == team.id}) else {
            return
        }
        self.userTeams[index].clear()
        self.userTeams.remove(at: index)
    }
    
    
    func addTeam(name: String) {
        let newTeam = Team(name: name)
        userTeams.append(newTeam)
    }
    
    
    func duplicateCheck(name: String) -> Bool {
        for team in userTeams {
            if team.name == name {
                return true
            }
        }
        return false
    }
    
    
    func deleteTeam(at offsets: IndexSet) {
        userTeams.remove(atOffsets: offsets)
    }
}
