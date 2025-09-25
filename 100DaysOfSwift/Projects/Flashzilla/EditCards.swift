//
//  EditCards.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 25/9/25.
//

import SwiftUI
import SwiftData

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    @Query private var cards: [Card]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
        }
    }
    
    func addCard() {
        let trimmedPrompts = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswers = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompts.isEmpty == false && trimmedAnswers.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompts, answer: trimmedAnswers)
        modelContext.insert(card)
        
        newPrompt = ""
        newAnswer = ""
    }
    
    func removeCards(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(cards[offset])
        }
    }
    
    func done() {
        dismiss()
    }
}

#Preview {
    EditCards()
}
