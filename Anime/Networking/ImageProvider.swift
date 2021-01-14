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
	
	/// Retrieves an image
	/// - Parameter url: url of the image
	func image(for url: URL) -> AnyPublisher<UIImage, ImageError> {
		return URLSession.shared.dataTaskPublisher(for: url)
			.retry(4)
			.tryMap {
				guard let img = UIImage(data: $0.data) else { throw ImageError.DecodingError }
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
