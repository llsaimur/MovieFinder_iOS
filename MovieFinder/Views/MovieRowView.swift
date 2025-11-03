struct MovieRowView: View {
    let movie: MovieSummary
    var body: some View {
        HStack {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill().frame(width: 60, height: 90).cornerRadius(6)
                default: Rectangle().fill(.gray).frame(width: 60, height: 90)
                }
            }
            VStack(alignment: .leading) {
                Text(movie.Title).font(.headline)
                Text(movie.Year).font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
}