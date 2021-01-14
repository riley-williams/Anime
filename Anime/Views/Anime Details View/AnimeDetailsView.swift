//
//  AnimeDetailsView.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import SwiftUI

/// Displays additional details about an anime
struct AnimeDetailsView: View {
	@ObservedObject var viewModel: AnimeDetailsViewModel
	
    var body: some View {
		Text(viewModel.anime.title)
    }
	
	init(anime: Anime) {
		self.viewModel = AnimeDetailsViewModel(anime)
	}
}

/*
struct AnimeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AnimeDetailsView()
    }
}
*/
