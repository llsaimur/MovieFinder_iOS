//
//  SectionCard.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/24/25.
//

import SwiftUI

struct SectionCard: View {
    let title: String
    let text: String
    var icon: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                }
                Text(title)
                    .font(.headline)
                    .bold()
            }

            Divider()

            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
