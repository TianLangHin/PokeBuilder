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
            Text("My Teams")
                .font(.largeTitle)
                .padding()
            List(teamList.userTeams) { team in
                NavigationLink(destination: TeamView(teamList: teamList, id: team.id)) {
                    LineupView(team: team)
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
    }
}

struct LineupView: View {

    @State var team: Team

    var body: some View {
        VStack {
            Text("\(team.name)")
                .font(.title2)
                .padding()
            HStack {
                ForEach(team.pokemon) { pokemon in
                    AsyncImage(url: pokemon.baseData.sprite)
                }
            }
        }
    }
}
