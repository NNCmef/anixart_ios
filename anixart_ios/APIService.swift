import Foundation

class APIService {
    static let shared = APIService()
    
    // ВАЖНО: Убедись, что IP совпадает с адресом ПК в локальной сети
    private let baseURL = "http://192.168.1.62:8000/api" 
    
    func searchAnime(query: String) async throws -> [Anime] {
        guard let urlString = "\(baseURL)/search?q=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Anime].self, from: data)
    }
    
    func fetchDetails(id: Int) async throws -> AnimeDetail {
        guard let url = URL(string: "\(baseURL)/anime/\(id)") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(AnimeDetail.self, from: data)
    }
    
    func fetchWatchLink(id: Int) async throws -> WatchResponse {
        guard let url = URL(string: "\(baseURL)/watch/\(id)") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WatchResponse.self, from: data)
    }
}
