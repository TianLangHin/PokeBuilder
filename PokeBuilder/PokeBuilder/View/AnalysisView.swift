//
//  AnalysisView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 6/5/2025.
//

import SwiftUI

struct AnalysisView: View {

    @StateObject var teamAnalysis = TeamAnalysisViewModel()

    @State var team: Team
    @State var defensiveCoverage: [String: Int] = [:]
    @State var offensiveCoverage: [String: Int] = [:]

    var body: some View {
        VStack {
            Text("Team Analysis")
                .font(.title)
                .padding()

            HStack {
                VStack {
                    Text("Defensive Coverage")
                        .padding()
                    List(Array(defensiveCoverage).sorted(by: { e1, e2 in
                        TeamAnalysisViewModel.typeNames.firstIndex(of: e1.key) ?? 0
                        < TeamAnalysisViewModel.typeNames.firstIndex(of: e2.key) ?? 0
                    }), id: \.key) { key, value in
                        Text("\(key.capitalized): \(value)")
                    }
                }
                VStack {
                    Text("Offensive Coverage")
                        .padding()
                    List(Array(offensiveCoverage).sorted(by: { e1, e2 in
                        TeamAnalysisViewModel.typeNames.firstIndex(of: e1.key) ?? 0
                        < TeamAnalysisViewModel.typeNames.firstIndex(of: e2.key) ?? 0
                    }), id: \.key) { key, value in
                        Text("\(key.capitalized): \(value)")
                    }
                }
            }
        }
        .onAppear(perform: {
            Task {
                await teamAnalysis.prepareTable()
                defensiveCoverage = teamAnalysis.defensiveCoverage(team: team)
                offensiveCoverage = await teamAnalysis.offensiveCoverage(team: team)
            }
        })
    }
}
