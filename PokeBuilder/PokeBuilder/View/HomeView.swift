//
//  HomeView.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 29/4/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            // Placeholder for background colour later
            Color.white.ignoresSafeArea()

            VStack {
                Spacer()
                Text("PokéBuilder")
                    .font(.largeTitle)
                Button(action: {
                    // Empty action to be completed with
                    // navigation functionality
                }) {
                    Text("View Teams")
                        .font(.title2)
                }
                .padding()
                .buttonStyle(.borderedProminent)
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
