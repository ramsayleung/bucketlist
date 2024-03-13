//
//  ContentModelView.swift
//  BucketList
//
//  Created by ramsayleung on 2024-03-12.
//

import Foundation
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations = [Location]()
        var selectedPlace: Location?
        var isUnlocked = false
        
        let savePath = URL.documentsDirectory.appending(path: "savedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath)
            }catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation(location: Location){
            locations.append(location)
            save()
        }
        
        func updateLocation(location: Location) {
            guard let selectedPlace else { return  }
            
            if let index = locations.firstIndex(of: selectedPlace){
                locations[index] = location
            }
            save()
        }
        
        func removeLocation(location: Location) {
            if let index = locations.firstIndex(of: location){
                locations.remove(at: index)
            }
            save()
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please authenticate yourself t unlock your places."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    }else{
                        // authentication error
                    }
                }
            }else{
                // no biometrics
            }
        }
    }
}
