//
//  AnimeCoverViewModel.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import SwiftUI
import Combine

class AnimeCoverViewModel: ObservableObject {
	var anime: Anime
	
	@Published var image: UIImage?
	
	private var imageCancellables: Set<AnyCancellable> = []
	private var isRetrievingImage: Bool = false
	
	init(_ anime: Anime) {
		self.anime = anime
		if let imageURLString = anime.imageURL,
		   let imageURL = URL(string: imageURLString) {
			image = ImageProvider.shared.cachedImage(for: imageURL)
		}
	}
	
	/// Attempts to retrieve the cover art
	func retrieveImage() {
		// Only try to get the image if it doesn't already exist and there is no current task
		if image == nil && !isRetrievingImage,
		   let imageURLString = anime.imageURL,
		   let imageURL = URL(string: imageURLString) {
			isRetrievingImage = true
			ImageProvider.shared.image(for: imageURL)
				.map { Optional.some($0) }
				.replaceError(with: nil)
				.receive(on: RunLoop.main)
				.sink {
					self.isRetrievingImage = false
					self.image = $0
				}.store(in: &imageCancellables)
		}
	}
	
}
