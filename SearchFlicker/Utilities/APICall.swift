//
//  APICall.swift
//  SearchFlicker
//
//

import Foundation
class APIClient {
    
    var baseULRStr = "https://api.flickr.com/services/feeds/photos_public.gne"
    func fetchItems(searchText: String) async throws -> FlickrResponse? {
        
            let baseURL = URL(string:baseULRStr )!
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            components?.queryItems = [
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "nojsoncallback", value: "1"),
                URLQueryItem(name: "tags", value: searchText)
            ]
            
            guard let url = components?.url else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            // Flickr API returns JSONP, so we need to remove the surrounding JavaScript function
            let jsonString = String(data: data, encoding: .utf8)?
                .replacingOccurrences(of: "jsonFlickrFeed(", with: "")
                .replacingOccurrences(of: ")", with: "")
            
            guard let cleanedData = jsonString?.data(using: .utf8) else {
                throw URLError(.cannotDecodeContentData)
            }
            
            let items = try JSONDecoder().decode(FlickrResponse.self, from: cleanedData)
            return items
        }
}
