//
//  MovieDetailContainerView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


//
//  MovieDetailContainer.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//

import SwiftUI

struct MovieDetailView: View {
    let imdbID: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)

            Text("Movie Details Coming Soon")
                .font(.title3)
                .bold()

            Text("IMDb ID: \(imdbID)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Movie Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MovieDetailContainer(imdbID: "tt1375666")
}
