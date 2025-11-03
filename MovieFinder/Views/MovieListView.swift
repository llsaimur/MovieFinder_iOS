//
//  MovieListView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.movies) { movie in
                NavigationLink(destination: MovieDetailView(imdbID: movie.imdbID)) {
                    MovieRowView(movie: movie)
                }
            }
        }
        .listStyle(.plain)
    }
}

