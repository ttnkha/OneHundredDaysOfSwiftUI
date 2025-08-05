    //
    //  iExpense.swift
    //  100DaysOfSwift
    //
    //  Created by Kha, Tran Thuy Nha on 29/7/25.
    //

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    
    var amountColor: Color {
        amount <= 10 ? .green : amount <= 100 ? .blue : .red
    }
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
    
    var personals: [ExpenseItem] {
        items.filter { $0.type == "Personal" }
    }
    
    var businesses: [ExpenseItem] {
        items.filter { $0.type == "Business" }
    }
}

struct iExpense: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Personal")) {
                    items(list: expenses.personals)
                }
                
                Section(header: Text("Business")) {
                    items(list: expenses.businesses)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func items(list: [ExpenseItem]) -> some View {
        ForEach(list) { item in
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.type)
                }
                
                Spacer()
                Text(item.amount, format: .currency(code: currencyCode))
                    .foregroundStyle(item.amountColor)
                    .font(.headline)
            }
        }
        .onDelete { offsets in
            let idsToDelete = offsets.map { list[$0].id }
            removeItems(at: idsToDelete)
        }
    }
}

private extension iExpense {
    func removeItems(at idsToDelete: [UUID]) {
        expenses.items.removeAll { item in
            idsToDelete.contains(item.id)
        }
    }
}

#Preview {
    iExpense()
}
