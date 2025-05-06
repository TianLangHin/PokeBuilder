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

    var body: some View {
        VStack {
            Text("Team Analysis")
                .font(.title)
                .padding()
            List(Array(defensiveCoverage).sorted(by: { e1, e2 in
                TeamAnalysisViewModel.typeNames.firstIndex(of: e1.key) ?? 0
                >= TeamAnalysisViewModel.typeNames.firstIndex(of: e2.key) ?? 0
            }), id: \.key) { key, value in
                Text("\(key): \(value)")
            }
        }
        .onAppear(perform: {
            Task {
                await teamAnalysis.prepareTable()
                defensiveCoverage = teamAnalysis.defensiveCoverage(team: team)
            }
        })
    }
}
