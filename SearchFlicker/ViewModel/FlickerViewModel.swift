import Foundation
import Combine

// Ensure that the ViewModel runs on the main thread
class FlickrViewModel: ObservableObject {
    @Published var items: [FlickerList] = []
    @Published var searchText: String = "" {
        didSet {
            guard !searchText.isEmpty else { return }
            Task {
                await fetchItems()
            }
        }
    }

    var apiClient = APIClient()
    var previosSearchText: String = ""
    init() {
        Task {
            await fetchItems()
        }
    }

//    init(apiClient: APIClient = APIClient()) {
//        self.apiClient = apiClient
//    }

    func fetchItems() async {
        do {
            guard let fetchedItems = try await apiClient.fetchItems(searchText: searchText) else {
                return
            }
            self.items = fetchedItems.items
        } catch {
            print("Failed to get flicker list: \(error)")
        }
    }

    var filteredItems: [FlickerList] {
        return items
    }
}
