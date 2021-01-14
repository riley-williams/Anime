//
//  AnimeDetailsViewModel.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import UIKit

class AnimeDetailsViewModel: ObservableObject {
	var anime: Anime
	
	init(_ anime: Anime) {
		self.anime = anime
	}
	
}
