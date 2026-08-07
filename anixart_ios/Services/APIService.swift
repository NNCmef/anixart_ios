import Foundation

class APIService {
    static let shared = APIService()
    
    // ВАЖНО: ЗАМЕНИ 192.168.X.X НА АДРЕС СВОЕГО КОМПА
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
    
    func fetchWatchLink(id: Int) async throws -> String {
        guard let url = URL(string: "\(baseURL)/watch/\(id)") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(WatchResponse.self, from: data)
        return response.link
    }
}
