import Foundation

struct Anime: Codable, Identifiable {
    let id: Int
    let title: String
    let posterUrl: String
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, status
        case posterUrl = "poster_url"
    }
}

struct AnimeDetail: Codable, Identifiable {
    let id: Int
    let title: String
    let posterUrl: String
    let description: String
    let genres: [String]
    let score: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, genres, score
        case posterUrl = "poster_url"
    }
}

struct WatchResponse: Codable {
    let link: String
}
