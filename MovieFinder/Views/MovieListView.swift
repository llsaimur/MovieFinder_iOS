import SwiftUI

struct MovieListView: View {
    let movies: [MovieSummary]

    var body: some View {
        List(movies) { movie in
            NavigationLink(destination: MovieDetailContainer(imdbID: movie.imdbID)) {
                MovieRowView(movie: movie)
            }
        }
        .listStyle(.plain)
    }
}
