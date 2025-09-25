//
//  Card.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 25/9/25.
//

import Foundation
import SwiftData

@Model
class Card {
    var id: UUID
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    
    init(prompt: String, answer: String) {
        self.id = UUID()
        self.prompt = prompt
        self.answer = answer
    }
}
