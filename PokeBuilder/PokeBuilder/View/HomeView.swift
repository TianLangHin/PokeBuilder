//
//  HomeView.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 29/4/2025.
//

import SwiftUI

struct HomeView: View {

    @StateObject var teamList = TeamListViewModel()

    @State var query = ""

    var body: some View {
        ZStack {
            // Placeholder for background colour later
            Color.white.ignoresSafeArea()

            NavigationView {
                VStack {
                    Spacer()
                    Text("PokéBuilder")
                        .font(.largeTitle)
                        .padding()
                    
                    NavigationLink(destination: TeamListView(teamList: teamList)) {
                        Text("View Teams")
                        .font(.title)
                        .frame(width: 180, height: 70)
                        .cornerRadius(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        .foregroundColor(.white)
                        .padding()
                        
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
