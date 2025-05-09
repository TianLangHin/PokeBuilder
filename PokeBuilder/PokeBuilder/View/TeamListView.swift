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
                    //Change it to a better pale color
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
                    // Some filtering can be done here to ensure
                    // a non-blank name and a non-duplicate.
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


#Preview{
    @Previewable @State var teamList: TeamListViewModel = .init()
    TeamListView(teamList: teamList)
}



//Note: Old list
//            List {
//                ForEach($teamList.userTeams) { $team in
//                    NavigationLink(destination: TeamView(team: $team)) {
//                        LineupView(team: team)
//                    }
//                    .listRowBackground((teamList.userTeams.count % 2 == 0) ? Color(hex: 0xFF7074) : Color.blue)
//                }
//            }
//            .scrollContentBackground(.hidden)



//ForEach(teamList.userTeams.indices, id: \.self) { index in
//    NavigationLink(destination: TeamView(team: $teamList.userTeams[index])) {
//        VStack{
//            Text("\(teamList.userTeams[index].name)")
//                .font(.title)
//            
//            GeometryReader { geometry in
//                let availableWidth = geometry.size.width * 0.9
//                let fixedSize = availableWidth / 6
//                
//                HStack {
//                    ForEach(teamList.userTeams[index].pokemon) { pokemon in
//                        AsyncImage(url: pokemon.baseData.sprite) { image in
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: fixedSize, height: fixedSize)
//                        }  placeholder: {
//                            LineupView(team: teamList.userTeams[index])
//                        }
//                    }
//                }
//                .padding(.top, (isPhone ? 0 : -15))
//            }
//        }
//        .padding(.bottom, (isPhone ? 8 : 80))
//   }
//}





//HStack {
//    ForEach(teamList.userTeams[index].pokemon) { pokemon in
//        AsyncImage(url: pokemon.baseData.sprite) { image in
//            image
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//        
//        }  placeholder: {
//            LineupView(team: team)
//        }
//    }
//}
//.padding(.top, (isPhone ? 0 : -15))
