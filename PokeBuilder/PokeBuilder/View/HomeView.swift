//
//  HomeView.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 29/4/2025.
//

import SwiftUI

struct HomeView: View {

    // The ViewModel handling the list of teams is initialised here
    // so that the entire app can access it.
    @StateObject var teamList = TeamListViewModel()

    var body: some View {
        // A NavigationStack is used to automatically implement backward navigation
        // since that is always a desirable feature according to our app logic.
        NavigationStack {
            ZStack {
                // PokeBall design for the title page.
                VStack {
                    Color.red.frame(maxWidth: .infinity, maxHeight: .infinity)
                    Rectangle()
                        .frame(height: 10)
                        .padding(.top, -10)
                    Color.white.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .ignoresSafeArea()

                VStack {
                    Spacer()
                    Text("PokéBuilder")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)

                    Spacer()
                        .frame(height: 100)

                    NavigationLink(destination: TeamListView(teamList: teamList)) {
                        Text("View Teams")
                            .font(.title)
                            .frame(width: 180, height: 80)
                            .cornerRadius(10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: 0x3b3b3b)))
                            .foregroundColor(.white)
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
