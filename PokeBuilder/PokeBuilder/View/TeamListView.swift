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
    
    var isPhone = (UIDevice.current.userInterfaceIdiom == .phone)
    
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
                    teamList.addTeam(name: newTeamName.trimmingCharacters(in: .whitespacesAndNewlines))
                    newTeamName = ""
                })
                .padding()
                .buttonStyle(.borderedProminent)
                .disabled(newTeamName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || teamList.duplicateCheck(name: newTeamName))
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
                .foregroundColor(Color.black)
                .fontWeight(.bold)
                
        }
    }
}

#Preview {
    @Previewable @State var teamList: TeamListViewModel = .init()
    TeamListView(teamList: teamList)
}
