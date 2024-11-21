//
//  FickerBase.swift
//  SearchFlicker
//
//

import Foundation

struct Media: Decodable {
    let m: URL
}

struct FlickerList: Decodable, Identifiable {
    var id = UUID() // Adding an id for Identifiable protocol
    let title: String
    let link: URL
    let media: Media
    let date_taken: String
    let description: String
    let published: String
    let author: String
    let author_id: String
    let tags: String
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case media
        case date_taken
        case description
        case published
        case author
        case author_id
        case tags
    }
}

struct FlickrResponse: Decodable {
    let title: String
    let link: URL
    let description: String
    let modified: String
    let generator: URL
    let items: [FlickerList]
    
    static let mockJSON = """
    {
        "title": "Recent Uploads tagged ape",
        "link": "https://www.flickr.com/photos/tags/ape/",
        "description": "",
        "modified": "2024-11-20T11:14:39Z",
        "generator": "https://www.flickr.com",
        "items": [
            {
                "title": "Piaggio Ape P501",
                "link": "https://www.flickr.com/photos/harry_nl/54153196105/",
                "media": {"m":"https://live.staticflickr.com/65535/54153196105_3dbe30ffa5_m.jpg"},
                "date_taken": "2024-11-09T16:29:05-08:00",
                "description": " <p><a href=\\"https://www.flickr.com/people/harry_nl/\\">harry_nl</a> posted a photo:</p> <p><a href=\\"https://www.flickr.com/photos/harry_nl/54153196105/\\" title=\\"Piaggio Ape P501\\"><img src=\\"https://live.staticflickr.com/65535/54153196105_3dbe30ffa5_m.jpg\\" width=\\"240\\" height=\\"180\\" alt=\\"Piaggio Ape P501\\" /></a></p> <p>Piaggio started building three-wheeled light commercial vehicles in 1948. It was more or less a Vespa with two rear wheels and a cabin. Models of the Ape changed over the years but are still available today. This one has a sticker from a dealer in Porto Sant'Elpidio, Italy.</p> ",
                "published": "2024-11-20T11:14:39Z",
                "author": "nobody@flickr.com (\\"harry_nl\\")",
                "author_id": "23363966@N02",
                "tags": "netherlands nederland 2024 utrecht piaggio ape p501"
            },
            {
                "title": "Mountain Gorillas -- (Gorilla gorilla); Albuquerque, NM, BioPark Zoo [Lou Feltz]",
                "link": "https://www.flickr.com/photos/lvfeltz/54150299417/",
                "media": {"m":"https://live.staticflickr.com/65535/54150299417_4109d4db9b_m.jpg"},
                "date_taken": "2024-10-04T10:39:54-08:00",
                "description": " <p><a href=\\"https://www.flickr.com/people/lvfeltz/\\">deserttoad</a> posted a photo:</p> <p><a href=\\"https://www.flickr.com/photos/lvfeltz/54150299417/\\" title=\\"Mountain Gorillas -- (Gorilla gorilla); Albuquerque, NM, BioPark Zoo [Lou Feltz]\\"><img src=\\"https://live.staticflickr.com/65535/54150299417_4109d4db9b_m.jpg\\" width=\\"240\\" height=\\"160\\" alt=\\"Mountain Gorillas -- (Gorilla gorilla); Albuquerque, NM, BioPark Zoo [Lou Feltz]\\" /></a></p> <p>You've got to love an animal whose scientific name is so easy to recall! Like for most of the great apes, this species suffers from habitat loss and poaching in its native Africa. Fortunately most of the great apes are zoo favorites in numerous zoos across the world. The gene diversity is thus being maintained. While I have seen images of young apes playing with the Silverbacks (males), most of the child tending seems to be done by the Moms.<br /> <br /> IMG_2886; Mountain Gorillas</p> ",
                "published": "2024-11-19T16:57:55Z",
                "author": "nobody@flickr.com (\\"deserttoad\\")",
                "author_id": "42415395@N07",
                "tags": "zoo nature park newmexico animal mammal ape gorilla"
            }
        ]
    }
    """
    
    static func getMackObject() -> FlickrResponse? {
        do {
            let jsonData = Data(mockJSON.utf8)
            let response = try JSONDecoder().decode(self, from: jsonData)
            print("Decoded response: \(response)")
            // Use `response.items` as the mock data in your tests
            return response
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }
}
