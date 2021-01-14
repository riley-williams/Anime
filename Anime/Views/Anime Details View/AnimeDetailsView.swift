//
//  AnimeDetailsView.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import Foundation
import SwiftUI

/// Displays additional details about an anime
struct AnimeDetailsView: View {
	@ObservedObject var viewModel: AnimeDetailsViewModel
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				HStack {
					Text(viewModel.anime.title)
					.font(.title)
					.padding(.top)
					Spacer()
				}
				HStack {
					if let airDate = viewModel.anime.airDate?.toDateISO() {
						Text(airDate.year)
					}
					
					Text(viewModel.anime.rating ?? "Unrated")
					
					Text("\(viewModel.anime.episodeCount ?? 1)ep")
				}.font(.body)
				HStack(alignment: .top) {
					AnimeCoverView(anime: viewModel.anime)
						.frame(maxWidth: 80)
					
					Text(viewModel.anime.synopsis ?? "No synopsis")
				}
				
				HStack {
					RatingMiniView(anime: viewModel.anime)
						
					ZStack {
						VStack(spacing: 0) {
							Image(systemName: "link")
								.font(.title)
								.foregroundColor(Color(.systemBlue))
								.padding(.bottom, 5)
							Text("Open")
								.bold()
						}.padding()
					}.frame(minWidth: 110, minHeight: 110)
					.background(Color(.secondarySystemFill))
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.onTapGesture {
						if let url = URL(string: viewModel.anime.url) {
							UIApplication.shared.open(url)
						}
					}
				}
				
			}
		}.navigationBarTitle(viewModel.anime.title, displayMode: .inline)
	}
	
	init(anime: Anime) {
		self.viewModel = AnimeDetailsViewModel(anime)
	}
}


struct AnimeDetailsView_Previews: PreviewProvider {
	private static var anime = Anime(id: 16498,
									 url: "https://myanimelist.net/anime/16498/Shingeki_no_Kyojin",
									 imageURL: "https://cdn.myanimelist.net/images/anime/10/47347.jpg?s=29949c6e892df123f0b0563e836d3d98",
									 title: "Shingeki no Kyojin",
									 isAiring: false,
									 synopsis: "Centuries ago, mankind was slaughtered to near extinction by monstrous humanoid creatures called titans, forcing humans to hide in fear behind enormous concentric walls. What makes these giants truly...",
									 type: "TV",
									 episodeCount: 25,
									 score: 8.47,
									 airDate: "2013-04-07T00:00:00+00:00",
									 endDate: "2013-09-29T00:00:00+00:00",
									 members: 2357843,
									 rating: "R")
	static var previews: some View {
		Group {
			AnimeDetailsView(anime: anime)
			.preferredColorScheme(.light)
			
			AnimeDetailsView(anime: anime)
			.previewDevice("iPad Pro (9.7-inch)")
			.preferredColorScheme(.dark)
		}
	}
}
