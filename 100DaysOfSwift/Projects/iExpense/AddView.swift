//
//  AddView.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 30/7/25.
//

import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
//    var expenses: [ExpenseItem]
    
    @State private var name = "Change name here"
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]
    
    var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: currencyCode))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    modelContext.insert(item)
//                    expenses.append(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView()
}
