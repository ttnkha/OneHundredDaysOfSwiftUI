//
//  ContentView.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 30/6/25.
//

import SwiftUI

struct ContentView: View {
    private let projects = Project.allCases

    var body: some View {
        NavigationStack {
            List(projects, id: \.rawValue) { project in
                NavigationLink {
                    destinationView(for: project)
                } label: {
                    Label(project.rawValue, systemImage: "folder")
                }
                
            }
            .navigationTitle("Projects")
        }
    }
}

extension ContentView {
    @ViewBuilder
    private func destinationView(for type: Project) -> some View {
        switch type {
            case .weSplit: WeSplit()
            case .converter: Converter()
            case .guessTheFlag: GuessTheFlag()
            case .viewsAndModifiers: ViewsAndModifiers()
            case .betterRest: BetterRest()
            case .wordScramble: WordScramble()
            case .animations: Animations()
            case .iexpense: iExpense()
            case .moonshot: Moonshot()
            case .navigation: Navigation()
        }
    }
}

#Preview {
    ContentView()
}
