//
//  HomeViewModel.swift
//  SearchFlicker
//
//  Created by Jagan Parigi on 11/20/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var items: [FlickerList] = []
    @Published var searchText: String = "" {
        didSet {
            debounceSearch()
        }
    }

    private var apiClient: APIClient
    private var debounceTask: Task<Void, Never>?
    private var cachedResults: [String: [FlickerList]] = [:]

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
        Task {
            await fetchItems()
        }
    }

    private func debounceSearch() {
        debounceTask?.cancel()
        debounceTask = Task {
            try await Task.sleep(nanoseconds: 500_000_000) // 500ms debounce
            guard !Task.isCancelled else { return }
            if !searchText.isEmpty {
                await fetchItems()
            }
        }
    }

    func fetchItems() async {
        if let cached = cachedResults[searchText] {
            DispatchQueue.main.async {
                self.items = cached
            }
            return
        }

        do {
            guard let fetchedItems = try await apiClient.fetchItems(searchText: searchText) else {
                return
            }
            DispatchQueue.main.async {
                self.items = fetchedItems.items
                self.cachedResults[self.searchText] = fetchedItems.items
            }
        } catch {
            print("Failed to get flicker list: \(error)")
        }
    }

    var filteredItems: [FlickerList] {
        return items
    }
}
