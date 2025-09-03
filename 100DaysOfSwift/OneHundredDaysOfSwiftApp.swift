//
//  _00DaysOfSwiftApp.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 30/6/25.
//

import SwiftData
import SwiftUI

@main
struct OneHundredDaysOfSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
