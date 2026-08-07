import SwiftUI

struct DetailView: View {
    let animeId: Int
    @State private var detail: AnimeDetail?
    @State private var watchLink: String?
    @State private var showPlayer = false
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            if let detail = detail {
                VStack(spacing: 16) {
                    AsyncImage(url: URL(string: detail.posterUrl)) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFit()
                        } else {
                            Color.gray.opacity(0.3)
                        }
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    
                    Text(detail.title)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Text(detail.genres.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let score = detail.score {
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Text(score).bold()
                        }
                    }
                    
                    Text(detail.description.replacingOccurrences(of: "\\[(.*?)\\]", with: "", options: .regularExpression))
                        .font(.body)
                        .padding()
                    
                    Button(action: {
                        fetchLinkAndPlay()
                    }) {
                        Text("Смотреть")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            } else if isLoading {
                ProgressView().padding(.top, 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                detail = try await APIService.shared.fetchDetails(id: animeId)
                isLoading = false
            } catch {
                print("Error fetching details: \(error)")
            }
        }
        .sheet(isPresented: $showPlayer) {
            if let url = URL(string: watchLink ?? "") {
                PlayerView(url: url)
            }
        }
    }
    
    private func fetchLinkAndPlay() {
        Task {
            do {
                watchLink = try await APIService.shared.fetchWatchLink(id: animeId)
                showPlayer = true
            } catch {
                print("Error fetching link: \(error)")
            }
        }
    }
}
