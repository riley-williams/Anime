//
//  RatingMiniView.swift
//  Anime
//
//  Created by Riley Williams on 1/14/21.
//

import SwiftUI


struct RatingMiniView: View {
	var anime: Anime
	
	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				Image(systemName: "star.fill")
					.font(.title)
					.foregroundColor(Color(.systemYellow))
					.padding(.bottom, 5)
				HStack(alignment: .bottom, spacing: 0) {
					Text("\(String(format: "%.1f", anime.score ?? 0.0))")
						.font(.title2)
						.bold()
					Text("/10")
						.font(.title3)
				}
				Text("\(anime.members)")
					.font(.caption)
			}.padding()
		}.frame(minWidth: 110, minHeight: 110)
		.background(Color(.secondarySystemFill))
		.clipShape(RoundedRectangle(cornerRadius: 10))
	}
}

/*
struct RatingMiniView_Previews: PreviewProvider {
    static var previews: some View {
        RatingMiniView()
    }
}
*/
