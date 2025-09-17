//
//  WikipediaResult.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 17/9/25.
//

import Foundation

struct WikipediaResult: Codable {
    let query: WikipediaQuery
}

struct WikipediaQuery: Codable {
    let pages: [Int: WikipediaPage]
}

struct WikipediaPage: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    static func <(lhs: WikipediaPage, rhs: WikipediaPage) -> Bool {
        lhs.title < rhs.title
    }
}
