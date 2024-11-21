import SwiftUI

struct FlickerListView: View {
    @StateObject private var viewModel = FlickrViewModel() // Use FlickrViewModel here
    @State private var searchText: String = "" // Maintain search text
    
    var body: some View {
        // Switch from NavigationView to NavigationStack for better state management
        NavigationStack {
            VStack {
                SearchView(text: $viewModel.searchText) // Bind searchText to view model's searchText
                    .padding(.horizontal)
                
                GeometryReader { geometry in
                    ScrollView {
                        let columns = [GridItem(.adaptive(minimum: geometry.size.width / 2 - 10))]
                        
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.filteredItems) { item in
                                // NavigationLink with proper stack behavior
                                NavigationLink(destination: FlickerDetailView(item: item)) {
                                    VStack {
                                        ImageLoadView(url: item.media.m)
                                            .frame(width: geometry.size.width / 2 - 10, height: geometry.size.width / 2 - 10)
                                        Text(item.title)
                                            .font(.caption)
                                            .lineLimit(1)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: geometry.size.width / 2 - 10)
                                }
                                .buttonStyle(PlainButtonStyle()) // Prevent any side effects from NavigationLink styles
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                }
            }
            .navigationBarTitle("Search Flickr")
            .onDisappear {
                // Ensure state persistence when the view disappears
                print("FlickerListView disappeared")
            }
        }
    }
}

#Preview {
    FlickerListView()
}
