//
//  ProspectEditView.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 19/9/25.
//

import SwiftUI

struct ProspectEditView: View {
    @Bindable var prospect: Prospect
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $prospect.name)
                        .textContentType(.name)
                        .font(.title)
                    
                    TextField("Email address", text: $prospect.emailAddress)
                        .textContentType(.emailAddress)
                        .font(.title)
                }
            }
            .toolbar {
                Button("Save") {
                    prospect.updated = Date()
                    try? modelContext.save()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ProspectEditView(prospect: Prospect(name: "Anonymous", emailAddress: "you@yourcontact.com", isContacted: false))
}
