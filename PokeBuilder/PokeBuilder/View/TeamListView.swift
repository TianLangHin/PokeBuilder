//
//  TeamListView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 5/5/2025.
//

import SwiftUI

struct TeamListView: View {

    @ObservedObject var teamList: TeamListViewModel
    @State var newTeamName = ""

    var body: some View {
        VStack {
            List {
                ForEach($teamList.userTeams) { $team in
                    NavigationLink(destination: TeamView(team: $team)) {
                        LineupView(team: team)
                    }
                }
            }
            Spacer()
            HStack {
                TextField("New Team Name", text: $newTeamName)
                Spacer()
                Button("Add Team", action: {
                    // Some filtering can be done here to ensure
                    // a non-blank name and a non-duplicate.
                    teamList.addTeam(name: newTeamName)
                    newTeamName = ""
                })
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .toolbarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("My Teams")
                    .font(.largeTitle)
            }
        }
    }
}

struct LineupView: View {

    @State var team: Team

    var body: some View {
        VStack {
            Text("\(team.name)")
                .font(.title2)
                .padding()
        }
    }
}


#Preview{
    @Previewable @State var teamList: TeamListViewModel = .init()
    TeamListView(teamList: teamList)
}


