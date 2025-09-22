//
//  Prospect.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 19/9/25.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    var updated: Date?
    
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
        self.updated = Date()
    }
}
