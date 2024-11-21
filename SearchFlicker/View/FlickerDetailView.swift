import SwiftUI

struct FlickerDetailView: View {
    let item: FlickerList

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) { // Align content to the left
                // Image display
                ImageLoadView(url: item.media.m)
                    .frame(height: 300)
                    .padding(.bottom, 10) // Add space below the image
                
                // Title
                Text(item.title)
                    .font(.title)
                    .padding([.leading, .bottom])

                
                // Description display (without HTML)
                if let cleanedDescription = cleanDescription(item.description) {
                    Text(cleanedDescription)
                        .padding([.leading, .bottom]) // Padding left and bottom
                }

                // Author display (extract name from author field)
                Text("Author: \(extractAuthorName(from: item.author))")
                    .padding([.leading, .bottom]) // Padding left and bottom
                
                // Formatted Published Date display
                if let formattedDate = formattedDate(from: item.published) {
                    Text("Published: \(formattedDate)")
                        .padding([.leading, .bottom]) // Padding left and bottom
                }

                // Image Dimensions display
                if let imageDimensions = extractImageDimensions(from: item.description) {
                    Text("Image Dimensions: \(imageDimensions.width) x \(imageDimensions.height)")
                        .padding([.leading, .bottom])
                }

                // Share button
                ShareLink(item: createShareContent()) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

               
                Spacer()
            }
            .navigationBarBackButtonHidden(false) // Ensure back button is visible
        }
    }

    // Function to clean HTML tags from the description
    func cleanDescription(_ html: String) -> String? {
        // Remove HTML tags
        guard let data = html.data(using: .utf8) else { return nil }
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string // Return plain text
        } catch {
            print("Error cleaning description: \(error)")
            return nil
        }
    }

    // Function to extract the author's name (no email)
    func extractAuthorName(from authorField: String) -> String {
        // Extract the author's name from the part in quotes
        if let startRange = authorField.range(of: "\""),
           let endRange = authorField.range(of: "\"", range: startRange.upperBound..<authorField.endIndex) {
            let authorName = authorField[startRange.upperBound..<endRange.lowerBound]
            return String(authorName)
        }
        return "Unknown Author" // If no name found, return a default string
    }

    // Function to format the published date
    func formattedDate(from dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            return formatter.string(from: date)
        }
        return nil
    }

    // Create content for sharing
    func createShareContent() -> String {
        let title = item.title
        let description = cleanDescription(item.description) ?? "No description available"
        let author = extractAuthorName(from: item.author)
        let published = formattedDate(from: item.published) ?? "Unknown Date"
        
        let shareText = """
        \(title)
        Author: \(author)
        Published: \(published)
        
        Description: \(description)
        """
        return shareText
    }

    // Function to extract the width and height of the image from the description field
    func extractImageDimensions(from description: String) -> (width: Int, height: Int)? {
        // Search for width and height in the HTML description
        let regex = try? NSRegularExpression(pattern: "width=\"(\\d+)\" height=\"(\\d+)\"", options: [])
        if let match = regex?.firstMatch(in: description, options: [], range: NSRange(description.startIndex..., in: description)) {
            if let widthRange = Range(match.range(at: 1), in: description),
               let heightRange = Range(match.range(at: 2), in: description) {
                let width = Int(description[widthRange]) ?? 0
                let height = Int(description[heightRange]) ?? 0
                return (width, height)
            }
        }
        return nil // If no dimensions are found
    }
}

#Preview {
    FlickerDetailView(item: FlickerList(
        title: "North American Porcupine",
        link: URL(string: "https://www.flickr.com/photos/schenfeld/54146489112/")!,
        media: Media(m: URL(string: "https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg")!),
        date_taken: "2023-06-07T15:37:45-08:00",
        description: "<p><a href=\"https://www.flickr.com/people/schenfeld/\">David Schenfeld</a> posted a photo:</p><p><a href=\"https://www.flickr.com/photos/schenfeld/54146489112/\" title=\"North American Porcupine\"><img src=\"https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg\" width=\"240\" height=\"160\" alt=\"North American Porcupine\" /></a></p><p>Cadillac Mountain, Acadia National Park, Maine</p>",
        published: "2024-11-18T02:53:13Z",
        author: "nobody@flickr.com (\"David Schenfeld\")",
        author_id: "17528760@N00",
        tags: "acadia maine porcupine barharbor unitedstates cadillacmountain mammal"
    ))
}
