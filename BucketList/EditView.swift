//
//  EditView.swift
//  BucketList
//
//  Created by ramsayleung on 2024-03-10.
//

import SwiftUI

struct EditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    var onDelete: (Location) -> Void
    @State private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $viewModel.name)
                    
                    TextField("Description", text: $viewModel.description)
                }
                Section("nearby"){
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            
                            + Text(": ") +
                            
                            Text(page.description)
                                .italic()
                            
                        }
                    case .failed:
                        Text("Please try again later")
                    }
                }
            }.navigationTitle("Place details")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading){
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading){
                        Button("Delete", role: .destructive) {
                            onDelete(viewModel.location)
                            dismiss()
                        }
                        .foregroundStyle(.red)
                    }
                    
                    ToolbarItem(placement: .confirmationAction){
                        Button("Save"){
                            onSave(viewModel.newLocation())
                            dismiss()
                        }
                    }
                }
        }.task {
            await viewModel.fetchNearbyPages()
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void, onDelete: @escaping (Location) -> Void){
        let viewModel = ViewModel(location: location)
        _viewModel = State(initialValue: viewModel)
        self.onSave = onSave
        self.onDelete = onDelete
    }
}

#Preview {
    let location = Location.example
    return EditView(location: location) {location in
        
    } onDelete: { location in
        print("Deleting")
    }
}
