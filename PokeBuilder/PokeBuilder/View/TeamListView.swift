//
//  TeamListView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 5/5/2025.
//

import SwiftUI

struct TeamListView: View {

    // The team list ViewModel is being passed as an argument from the parent view.
    @ObservedObject var teamList: TeamListViewModel

    // State to store the name of a new team being created.
    @State var newTeamName = ""

    var body: some View {
        VStack {
            List {
                ForEach($teamList.userTeams, id: \.id) { $team in
                    NavigationLink(destination: TeamView(team: $team)) {
                        LineupView(team: team)
                    }
                    .listRowBackground(Color(hex: 0xFFADB0))
                }
                .onDelete(perform: teamList.deleteTeam)
            }
            .scrollContentBackground(.hidden)

            Spacer()

            HStack {
                TextField("New Team Name", text: $newTeamName)
                    .autocorrectionDisabled(true)
                Spacer()
                Button("Add Team", action: {
                    // When a team is added, we trim whitespace for intuitive bookkeeping.
                    teamList.addTeam(name: newTeamName.trimmingCharacters(in: .whitespacesAndNewlines))
                    newTeamName = ""
                })
                .padding()
                .buttonStyle(.borderedProminent)
                .disabled(newTeamName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || teamList.duplicateCheck(name: newTeamName))
                // We also disable duplicate team names, hence the last line here.
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

// This View represents a singular team in the team list.
struct LineupView: View {

    @State var team: Team

    var body: some View {
        VStack {
            Text("\(team.name)")
                .font(.title2)
                .padding()
                .foregroundColor(Color.black)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    @Previewable @State var teamList: TeamListViewModel = .init()
    TeamListView(teamList: teamList)
}
