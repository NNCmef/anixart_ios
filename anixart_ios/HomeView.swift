import SwiftUI

struct HomeView: View {
    @State private var query = ""
    @State private var results: [Anime] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            List(results) { anime in
                NavigationLink(destination: DetailView(animeId: anime.id)) {
                    HStack(alignment: .top, spacing: 12) {
                        AsyncImage(url: URL(string: anime.posterUrl)) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: 70, height: 100)
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(anime.title)
                                .font(.headline)
                                .lineLimit(2)
                            Text(anime.status ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Поиск аниме")
            .searchable(text: $query, prompt: "Название аниме...")
            .onSubmit(of: .search) {
                performSearch()
            }
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
        }
    }
    
    private func performSearch() {
        guard !query.isEmpty else { return }
        isLoading = true
        Task {
            do {
                results = try await APIService.shared.searchAnime(query: query)
            } catch {
                print("Error searching: \(error)")
            }
            isLoading = false
        }
    }
}
