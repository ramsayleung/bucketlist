//
//  ContentView.swift
//  BucketList
//
//  Created by ramsayleung on 2024-03-08.
//

import SwiftUI
import MapKit
import LocalAuthentication


struct ContentView: View {
    enum LoadingState {
        case loading, success, fail
    }
    
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    @State var locations = [Location]()
    @State var selectedPlace: Location?
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition){
                ForEach(locations){ location in
                    Annotation(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)){
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                            .onLongPressGesture {
                                selectedPlace = location
                            }
                    }
                }
            }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        let location = Location(id: UUID(), name: "New Location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                        locations.append(location)
                    }
                }.sheet(item: $selectedPlace){ place in
                    EditView(location: place){ newLocation in
                        if let index = locations.firstIndex(of: place){
                            locations[index] = newLocation
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
