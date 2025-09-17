//
//  LocationEditView-ViewModel.swift
//  100DaysOfSwift
//
//  Created by Kha, Tran Thuy Nha on 17/9/25.
//

import Foundation
import MapKit

extension LocationEditView {
    @Observable
    class ViewModel {
        
        var name: String = ""
        var description: String = ""
        
        private(set) var loadingState: LoadingState = .loading
        private(set) var pages = [WikipediaPage]()
        
        func fetchNearbyPlaces(latitude: Double, longitude: Double) async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(latitude)%7C\(longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let items = try JSONDecoder().decode(WikipediaResult.self, from: data)
                
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
    }
}
