//
//  AnalysisView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 6/5/2025.
//

import SwiftUI

struct AnalysisView: View {

    // When and `AnalysisView` is initialised,
    // it must first know which team it is analysing.
    @State var team: Team

    // Upon startup, it will inititalise a `TeamAnalysisViewModel`
    // and initialise the type coverage tables.
    @StateObject var teamAnalysis = TeamAnalysisViewModel()
    @State var defensiveCoverage: [String: Int] = [:]
    @State var offensiveCoverage: [String: Int] = [:]

    // Since initial startup may take long to query the API,
    // we have variables to manage "Loading..." indicators.
    @State var isLoadingDefense = true
    @State var isLoadingOffense = true

    var body: some View {
        VStack {
            Text("Team Analysis")
                .font(.title)
                .padding()

            HStack {
                VStack {
                    Text("Defensive Coverage")
                        .padding()

                    // Since this may take a long time to load,
                    // we have a loading indicator before type matchups have finished loading.
                    if isLoadingDefense {
                        VStack {
                            Spacer()
                            Text("Loading...")
                            Spacer()
                        }
                    } else {
                        // We then list the matchup scores against each of the types,
                        // listed in order of the predefined list of type names (`typeNames`).
                        List(Array(defensiveCoverage).sorted(by: { e1, e2 in
                            TeamAnalysisViewModel.typeNames.firstIndex(of: e1.key) ?? 0
                            < TeamAnalysisViewModel.typeNames.firstIndex(of: e2.key) ?? 0
                        }), id: \.key) { key, value in
                            Text("\(key.capitalized): \(value)")
                        }
                    }
                }
                VStack {
                    Text("Offensive Coverage")
                        .padding()

                    // Since this may take a long time to load,
                    // we have a loading indicator before type matchups have finished loading.
                    if isLoadingOffense {
                        VStack {
                            Spacer()
                            Text("Loading...")
                            Spacer()
                        }
                    } else {
                        // We list the matchup scores against each of the types,
                        // listed in order of the predefined list of type names (`typeNames`),
                        // just as was done for the defensive coverage.
                        List(Array(offensiveCoverage).sorted(by: { e1, e2 in
                            TeamAnalysisViewModel.typeNames.firstIndex(of: e1.key) ?? 0
                            < TeamAnalysisViewModel.typeNames.firstIndex(of: e2.key) ?? 0
                        }), id: \.key) { key, value in
                            Text("\(key.capitalized): \(value)")
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            // Since the calls to the API require async/await,
            // we start the asynchronous task of loading the type matchups
            // upon startup of the `AnalysisView`.
            // This may take some time since it needs to query 18 times in one load.
            Task {
                await teamAnalysis.prepareTable()
                defensiveCoverage = teamAnalysis.defensiveCoverage(team: team)
                isLoadingDefense = false
                offensiveCoverage = await teamAnalysis.offensiveCoverage(team: team)
                isLoadingOffense = false
            }
        })
    }
}
