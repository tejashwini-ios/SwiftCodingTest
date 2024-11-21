//
//  APIClientProtocol.swift
//  SearchFlicker
//
//  Created by Jagan Parigi on 11/20/24.
//


import Foundation

// API Client Protocol
protocol APIClientProtocol {
    func fetchItems(searchText: String) async throws -> FlickrResponse?
}

// A real implementation of APIClient, which could make network requests
class APIClient: APIClientProtocol {
    func fetchItems(searchText: String) async throws -> FlickrResponse? {
        // Normally here you'd make a network call, for example using URLSession
        guard let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?tags=\(searchText)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Parse the data into the model (you'd typically use a decoder here)
        let decoder = JSONDecoder()
        let response = try decoder.decode(FlickrResponse.self, from: data)
        
        return response
    }
}
