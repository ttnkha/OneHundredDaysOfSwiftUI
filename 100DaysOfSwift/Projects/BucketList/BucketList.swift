//
//  BucketList.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 9/9/25.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct BucketList: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: Location.example.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                                .onTapGesture {
                                    viewModel.selectedPlace = location
                                }
                        }
                    }
                }
                .mapStyle(viewModel.mapMode.style)
//                .onTapGesture { position in
//                    if let coordinate = proxy.convert(position, from: .local) {
//                        viewModel.addLocation(at: coordinate)
//                    }
//                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    LocationEditView(location: place) {
                        viewModel.update(location: $0)
                    }
                }
                .toolbar {
                    Button("Switch Map Mode", systemImage: "map") {
                        viewModel.update(mapMode: viewModel.mapMode.next)
                    }
                    .padding()
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert("Authentication Error", isPresented: $viewModel.showingErrorAlert, actions: {
                    Button("OK", role: .cancel) {}
                }, message: {
                    Text(viewModel.errorMessage ?? "An unknown error occurred.")
                })
        }
    }
}

#Preview {
    BucketList()
}
