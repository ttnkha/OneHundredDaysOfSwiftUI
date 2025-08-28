//
//  Order.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 26/8/25.
//

import SwiftUI

class Address: Codable {
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        ![name, streetAddress, city, zip].contains {
            $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}

@Observable
class Order: Codable {
    private let userDefaultsKey = "cupcake-corner@address"

    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _address = "address"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var address = Address() {
        didSet {
            if let encoded = try? JSONEncoder().encode(address) {
                UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            }
        }
    }
    
    init() {
        if let savedItem = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                address = try JSONDecoder().decode(Address.self, from: savedItem)
            } catch {
                print("Failed to decode saved address:", error)
            }
        }
    }
    
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        
        cost += Decimal(type) / 2
        
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
}
