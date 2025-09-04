//
//  iExpense.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 29/7/25.
//

import SwiftData
import SwiftUI

//struct ExpenseItem: Identifiable, Codable {
//    var id = UUID()
//    let name: String
//    let type: String
//    let amount: Double
//    
//    var amountColor: Color {
//        amount <= 10 ? .green : amount <= 100 ? .blue : .red
//    }
//}

//@Observable
//class Expenses {
//    var items = [ExpenseItem]() {
//        didSet {
//            if let encoded = try? JSONEncoder().encode(items) {
//                UserDefaults.standard.set(encoded, forKey: "Items")
//            }
//        }
//    }
//    
//    init() {
//        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
//            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
//                items = decodedItems
//                return
//            }
//        }
//        
//        items = []
//    }
//    
//    var personals: [ExpenseItem] {
//        items.filter { $0.type == "Personal" }
//    }
//    
//    var businesses: [ExpenseItem] {
//        items.filter { $0.type == "Business" }
//    }
//}

@Model
class ExpenseItem {
    var name: String
    var type: String
    var amount: Double
    
    var amountColor: Color {
        amount <= 10 ? .green : amount <= 100 ? .blue : .red
    }
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}

enum ExpenseFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case personal = "Personal"
    case business = "Business"
    
    var id: String { self.rawValue }
}

struct ExpenseItemView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    
    var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
    
    init(type: String, sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(filter: #Predicate<ExpenseItem> { item in
            item.type == type
        }, sort: sortOrder)
    }
    
    var body: some View {
        ForEach(expenses) { item in
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
        .onDelete(perform: removeItems)
    }
    
    func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
    }
}

struct iExpense: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount),
    ]
    @State private var selectedFilter: ExpenseFilter = .all
    
    @State private var showingAddExpense = false
    
    var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
    
    var body: some View {
        NavigationStack {
            List {
                if selectedFilter != .business {
                    Section(header: Text("Personal")) {
                            //                    items(list: personals)
                        ExpenseItemView(type: "Personal", sortOrder: sortOrder)
                    }
                }
                
                if selectedFilter != .personal {
                    Section(header: Text("Business")) {
                            //                    items(list: businesses)
                        ExpenseItemView(type: "Business", sortOrder: sortOrder)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\ExpenseItem.name),
                                SortDescriptor(\ExpenseItem.amount),
                            ])
                        
                        Text("Sort by Amount")
                            .tag([
                                SortDescriptor(\ExpenseItem.amount),
                                SortDescriptor(\ExpenseItem.name),
                            ])
                    }
                }
                
                Menu("Filter", systemImage: "line.3.horizontal.decrease") {
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(ExpenseFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                }
            }
//            .sheet(isPresented: $showingAddExpense) {
//                AddView(expenses: expenses)
//            }
            NavigationLink("") {
                EmptyView()
            }
            .navigationDestination(isPresented: $showingAddExpense) {
                AddView()
                    .navigationBarBackButtonHidden()
            }
            .onAppear {
                addSample()
            }
        }
    }
    
//    func items(list: [ExpenseItem]) -> some View {
//        ForEach(list) { item in
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(item.name)
//                        .font(.headline)
//                    Text(item.type)
//                }
//                
//                Spacer()
//                Text(item.amount, format: .currency(code: currencyCode))
//                    .foregroundStyle(item.amountColor)
//                    .font(.headline)
//            }
//        }
//        .onDelete { offsets in
//            let idsToDelete = offsets.map { list[$0].id }
//            removeItems(at: idsToDelete)
//        }
//    }
    
    func addSample() {
        try? modelContext.delete(model: ExpenseItem.self)
        
        let personal1 = ExpenseItem(name: "Piper Chapman", type: "Personal", amount: 5)
        let personal2 = ExpenseItem(name: "Organize sock drawer", type: "Personal", amount: 35)
        let business1 = ExpenseItem(name: "Make plans with Alex", type: "Business", amount: 15)
        let business2 = ExpenseItem(name: "Wakeeee", type: "Business", amount: 215)
        
        modelContext.insert(personal1)
        modelContext.insert(personal2)
        modelContext.insert(business1)
        modelContext.insert(business2)
    }
}

//private extension iExpense {
//    func removeItems(at idsToDelete: [UUID]) {
//        expenses.items.removeAll { item in
//            idsToDelete.contains(item.id)
//        }
//    }
//}

#Preview {
    iExpense().modelContainer(for: ExpenseItem.self, inMemory: true)
}
