//
//  AnimeCoverView.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import SwiftUI
import Combine

/// Displays a preview of an anime cover
struct AnimeCoverView: View {
	@ObservedObject private var viewModel: AnimeCoverViewModel
	
    var body: some View {
		ZStack {
			if let image = viewModel.image {
				
				Image(uiImage: image)
					.resizable()
					.scaledToFit()
				
			} else {
				
				ZStack {
					Color.gray
					Image(systemName: "ellipsis")
						.font(.title2)
						.foregroundColor(.white)
						.onAppear { viewModel.retrieveImage() }
				}.aspectRatio(0.75, contentMode: .fit)
				
			}
		}.clipShape(RoundedRectangle(cornerRadius: 10))
    }
	
	/// - Parameters:
	///   - anime: Anime model object
	///   - preloadImage: Set to true if the image should be downloaded before the view appears
	init(anime: Anime, preloadImage: Bool = false) {
		self.viewModel = AnimeCoverViewModel(anime)
		if preloadImage {
			viewModel.retrieveImage()
		}
	}

}


/*
struct AnimeCoverView_Previews: PreviewProvider {
    static var previews: some View {
        AnimeCoverView()
    }
}

*/
