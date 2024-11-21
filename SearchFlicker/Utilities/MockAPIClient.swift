//
//  MockAPIClient.swift
//  SearchFlicker
//
//  Created by Jagan Parigi on 11/21/24.
//


//
//  MockAPIClient.swift
//  SearchFlicker
//
//
import Foundation

class MockAPIClient: APIClient {
    var fetchItemsCalled = false
    var simulatedResult: FlickrResponse?


    override func fetchItems(searchText: String) async  -> FlickrResponse? {
        fetchItemsCalled = true
        if searchText.isEmpty {
            fetchItemsCalled = false
            return nil
        }
        if simulatedResult != nil {
            return simulatedResult
        } else {
            return nil
//            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
    }
}

