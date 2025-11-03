//
//  MovieRowView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            // Poster image
            if movie.poster != "N/A", let url = URL(string: movie.poster) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 60, height: 90)
                                .cornerRadius(6)
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 90)
                            .clipped()
                            .cornerRadius(6)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 90)
                            .cornerRadius(6)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.white.opacity(0.6))
                            )
                    default:
                        EmptyView()
                    }
                }
            } else {
                // Placeholder when no poster is available
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 90)
                    .cornerRadius(6)
                    .overlay(
                        Image(systemName: "film")
                            .foregroundColor(.white.opacity(0.6))
                    )
            }

            // Movie info
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(movie.year)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(movie.type.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}
