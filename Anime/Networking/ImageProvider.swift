//
//  ImageProvider.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import SwiftUI
import Combine
import Foundation

/// Provides images
class ImageProvider {
	/// The shared provider, to allow caching of images
	static var shared = ImageProvider()
	
	var cache = Cache<URL, UIImage>()
	
	/// Returns the image for the provided url only if it has been cached
	/// - Parameter url: image url
	/// - Returns: image at the url or nil
	func cachedImage(for url: URL) -> UIImage? {
		return cache[url]
	}
	
	/// Retrieves an image
	/// - Parameter url: url of the image
	func image(for url: URL) -> AnyPublisher<UIImage, ImageError> {
		if let img = cachedImage(for: url) {
			return Just(img)
				.setFailureType(to: ImageError.self)
				.eraseToAnyPublisher()
		}
		
		return URLSession.shared.dataTaskPublisher(for: url)
			.retry(4)
			.tryMap { [weak self] in
				guard let img = UIImage(data: $0.data) else { throw ImageError.DecodingError }
				self?.cache[url] = img
				return img
			}.mapError {
				switch $0 as? ImageError {
				case .DecodingError:
					return .DecodingError
				default:
					return .NetworkError
				}
			}.eraseToAnyPublisher()
	}

	enum ImageError: Error {
		case DecodingError
		case NetworkError
	}
}
