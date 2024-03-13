//
//  ContentView.swift
//  BucketList
//
//  Created by ramsayleung on 2024-03-08.
//

import SwiftUI
import MapKit


struct ContentView: View {
    enum LoadingState {
        case loading, success, fail
    }
    
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    @State private var viewModel = ViewModel()
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPosition){
                    ForEach(viewModel.locations){ location in
                        Annotation(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)){
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())

                               .onLongPressGesture {
                                    viewModel.selectedPlace = location
                                }
                               .onTapGesture {
                                   print("Tap to cancel: \(location)")
                                   viewModel.removeLocation(location: location)
                               }
                            // tap to cancel
                        }
                    }
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        let location = Location(id: UUID(), name: "New Location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                        print("Tap to add location")
                        viewModel.addLocation(location: location)
                    }
                }.sheet(item: $viewModel.selectedPlace){ place in
                    EditView(location: place){
                        viewModel.updateLocation(location: $0)
                    } onDelete: {
                        viewModel.removeLocation(location: $0)
                    }
                }
            }
        }else {
            Button("Unlock your places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    ContentView()
}
