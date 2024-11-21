//
//  HomeViewModelTests.swift
//  SearchFlicker
//
//  Created by Jagan Parigi on 11/20/24.
//


import XCTest
@testable import SearchFlicker

class HomeViewModelTests: XCTestCase {
    func testFetchItems() async {
        let viewModel = HomeViewModel()
        viewModel.apiClient = MockAPIClient()
        await viewModel.fetchItems()
        XCTAssertFalse(viewModel.items.isEmpty)
    }
}

class MockAPIClient: APIClient {
    override func fetchItems(searchText: String) async throws -> FlickrResponse? {
        let mockResponse = FlickrResponse(
            title: "Mock Title",
            link: URL(string: "https://example.com")!,
            description: "Mock Description",
            modified: "2022-01-01T00:00:00Z",
            generator: URL(string: "https://example.com")!,
            items: [
                FlickerList(
                    title: "Mock Item",
                    link: URL(string: "https://example.com")!,
                    media: Media(m: URL(string: "https://example.com/image.jpg")!),
                    date_taken: "2022-01-01T00:00:00Z",
                    description: "Mock Description",
                    published: "2022-01-01T00:00:00Z",
                    author: "Mock Author",
                    author_id: "MockID",
                    tags: "mock, test"
                )
            ]
        )
        return mockResponse
    }
}
