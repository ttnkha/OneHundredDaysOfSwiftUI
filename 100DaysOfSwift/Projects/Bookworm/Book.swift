//
//  Book.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 3/9/25.
//

import Foundation
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var date: Date?
    
    init(title: String, author: String, genre: String, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
        self.date = Date.now
    }
    
    var formattedDate: String {
        date?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}
