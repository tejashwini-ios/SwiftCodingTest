//
//  SearchFlickerTests.swift
//  SearchFlickerTests
//
//

import XCTest
@testable import SearchFlicker
import SwiftUI

@MainActor
final class HomeViewModelTests: XCTestCase {
    var viewModel: FlickrViewModel!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        viewModel = FlickrViewModel()
        viewModel.apiClient = mockAPIClient
    }

    override func tearDown() {
        viewModel = nil
        mockAPIClient = nil
        super.tearDown()
    }

    func testFetchItemsSuccess() async {
        mockAPIClient.simulatedResult = FlickrResponse.getMackObject()
        // Act
        viewModel.searchText = "Test"
        viewModel.items = await mockAPIClient.fetchItems(searchText: viewModel.searchText)?.items ?? []
        await Task.yield() // Let the async operation complete

        // Assert
        XCTAssertTrue(mockAPIClient.fetchItemsCalled, "fetchItems should be called")
        XCTAssertEqual(viewModel.items.count, 2, "The items array should contain the correct number of items")
        XCTAssertEqual(viewModel.items.first?.title, "Piaggio Ape P501", "The first item title should match the mock data")
    }

    func testFetchItemsFailure() async {
        // Arrange
        mockAPIClient.simulatedResult = nil // Simulate failure

        // Act
        viewModel.searchText = "Test"
        viewModel.items = await mockAPIClient.fetchItems(searchText: viewModel.searchText)?.items ?? []
        await Task.yield() // Let the async operation complete

        // Assert
        XCTAssertTrue(mockAPIClient.fetchItemsCalled, "fetchItems should be called")
        XCTAssertTrue(viewModel.items.isEmpty, "The items array should remain empty on failure")
    }

    func testSearchTextTriggersFetchItems() async {
        // Arrange
        mockAPIClient.simulatedResult = FlickrResponse.getMackObject()

        // Act
        viewModel.searchText = "Test"
        viewModel.items = await mockAPIClient.fetchItems(searchText: viewModel.searchText)?.items ?? []
        await Task.yield() // Let the async operation complete

        // Assert
        XCTAssertTrue(mockAPIClient.fetchItemsCalled, "fetchItems should be called when searchText changes")
        XCTAssertEqual(viewModel.previosSearchText, "", "previosSearchText should be updated after fetchItems")
    }
    
    func testNoFetchOnEmptySearchText() async {
           // Act
           viewModel.searchText = ""
        viewModel.items = await mockAPIClient.fetchItems(searchText: viewModel.searchText)?.items ?? []
           await Task.yield() // Let the async operation complete

           // Assert
           XCTAssertFalse(mockAPIClient.fetchItemsCalled, "fetchItems should not be called when searchText is empty")
       }
    
    // Test to ensure author name extraction works correctly
    func testExtractAuthorName() {
        let author = "nobody@flickr.com (\"David Schenfeld\")"
        
        // Create an instance of FlickerDetailView
        let flickerItem = FlickerList(
            title: "North American Porcupine",
            link: URL(string: "https://www.flickr.com/photos/schenfeld/54146489112/")!,
            media: Media(m: URL(string: "https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg")!),
            date_taken: "2023-06-07T15:37:45-08:00",
            description: "",
            published: "2024-11-18T02:53:13Z",
            author: "nobody@flickr.com (\"David Schenfeld\")",
            author_id: "17528760@N00",
            tags: ""
        )
        
        // Instantiate FlickerDetailView
        let view = FlickerDetailView(item: flickerItem)
        
        // Call the method on the instance
        let authorName = view.extractAuthorName(from: author)
        XCTAssertEqual(authorName, "David Schenfeld", "Author extraction failed")
    }

   
    
    // Test to ensure invalid date returns nil
    func testInvalidDateFormatting() {
        let invalidDateString = "invalid-date"
        
        // Create an instance of FlickerDetailView
        let flickerItem = FlickerList(
            title: "North American Porcupine",
            link: URL(string: "https://www.flickr.com/photos/schenfeld/54146489112/")!,
            media: Media(m: URL(string: "https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg")!),
            date_taken: "2023-06-07T15:37:45-08:00",
            description: "",
            published: invalidDateString,
            author: "",
            author_id: "17528760@N00",
            tags: ""
        )
        
        // Instantiate FlickerDetailView
        let view = FlickerDetailView(item: flickerItem)
        
        // Call the method on the instance
        let formattedDate = view.formattedDate(from: invalidDateString)
        XCTAssertNil(formattedDate, "Invalid date should return nil")
    }

    // Test to ensure `FlickerDetailView` can correctly bind to a `FlickerList` object
    func testFlickerDetailViewBindings() {
        // Sample `FlickerList` item
        let flickerItem = FlickerList(
            title: "North American Porcupine",
            link: URL(string: "https://www.flickr.com/photos/schenfeld/54146489112/")!,
            media: Media(m: URL(string: "https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg")!),
            date_taken: "2023-06-07T15:37:45-08:00",
            description: "<p><a href=\"https://www.flickr.com/people/schenfeld/\">David Schenfeld</a> posted a photo:</p><p><a href=\"https://www.flickr.com/photos/schenfeld/54146489112/\" title=\"North American Porcupine\"><img src=\"https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg\" width=\"240\" height=\"160\" alt=\"North American Porcupine\" /></a></p><p>Cadillac Mountain, Acadia National Park, Maine</p>",
            published: "2024-11-18T02:53:13Z",
            author: "nobody@flickr.com (\"David Schenfeld\")",
            author_id: "17528760@N00",
            tags: "acadia maine porcupine barharbor unitedstates cadillacmountain mammal"
        )

        // Create the view
        let view = FlickerDetailView(item: flickerItem)

        // Convert view to a snapshot for testing (if applicable)
        let viewController = UIHostingController(rootView: view)
        XCTAssertNotNil(viewController.view, "FlickerDetailView should load successfully")
    }
}
