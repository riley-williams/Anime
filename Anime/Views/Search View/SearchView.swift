//
//  SearchView.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import SwiftUI

/// A view that allows searching Animes and displaying a list of results
struct SearchView: View {
	@Namespace var searchViewNamespace
	
	@StateObject var viewModel = SearchViewModel()
	@State var displayMode: DisplayMode = .Grid
	
	private var columns = [GridItem(.adaptive(minimum: 150), spacing: 15, alignment: .bottom)]
	
	var body: some View {
		VStack {
			TextField("Search", text: $viewModel.keyword)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding([.top, .horizontal])
			
			Picker("View mode", selection: $displayMode) {
				Image(systemName: "rectangle.grid.3x2" + (displayMode == .Grid ? ".fill" : "") )
					.tag(DisplayMode.Grid)
				Image(systemName: "rectangle.grid.1x2" + (displayMode == .List ? ".fill" : "") )
					.tag(DisplayMode.List)
			}.pickerStyle(SegmentedPickerStyle())
			.padding(.horizontal)
			
			if let message = viewModel.message {
				Spacer()
				Text(message)
				Spacer()
			} else {
				if viewModel.results.count == 0 && viewModel.keyword.count >= 3 {
					Spacer()
					Text("Searching...")
					Spacer()
				} else {
					ScrollView(.vertical, showsIndicators: false) {
						switch displayMode {
						case .List:
							LazyVStack { // List seems to not like matchedGeometryEffect when used here
								ForEach(viewModel.results) { anime in
									NavigationLink(destination: AnimeDetailsView(anime: anime)) {
										HStack {
											AnimeCoverView(anime: anime, preloadImage: true)
												.matchedGeometryEffect(id: anime.id, in: searchViewNamespace, isSource: false)
											
											VStack(alignment: .leading) {
												Text(anime.title)
													.font(.title2)
												HStack {
													if let airDate = anime.airDate?.toDateISO() {
														Text(airDate.year)
													}
													
													Text(anime.rating ?? "Unrated")
													
													Text("\(anime.episodeCount ?? 1)ep")
													
													if let score = anime.score {
														HStack(alignment: .bottom, spacing: 0) {
															Text("\(String(format: "%.1f", score))")
																.bold()
															Text("/10")
														}.foregroundColor(Color(.systemYellow))
													}
												}.font(.body)
											}
											Spacer()
										}.padding(.horizontal)
										.background(Color(.systemBackground))
									}.buttonStyle(PlainButtonStyle())
									.frame(idealHeight: 80)
									
									Divider()
										.padding(.horizontal)
								}
							}
						case .Grid:
							LazyVGrid(columns: columns, spacing: 15) {
								ForEach(viewModel.results) { anime in
									NavigationLink(destination: AnimeDetailsView(anime: anime)) {
										VStack {
											AnimeCoverView(anime: anime, preloadImage: true)
												.matchedGeometryEffect(id: anime.id, in: searchViewNamespace)
												.shadow(radius: 5)
											
											Text(anime.title)
												.lineLimit(1)
										}
									}.buttonStyle(PlainButtonStyle())
								}
							}.padding(15)
						}
					}.animation(.easeInOut)
				}
			}
		}
		.navigationBarHidden(true)
		
	}
	
	enum DisplayMode {
		case Grid
		case List
	}
}

struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView()
	}
}
