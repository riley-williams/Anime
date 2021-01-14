//
//  AnimeSearchProvider.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import Combine

/// An object that can retrieve the results of searches
protocol AnimeSearchProvider {
	
	/// Obtains a list of Animes related to the provided keyword
	/// - Parameter title: keyword to search for
	func search(keyword: String) -> AnyPublisher<[Anime], SearchError>
}


enum SearchError: Error {
	/// The host failed to respond in a reasonable time
	case Unresponsive
	/// The response could not be decoded
	case DecodingError
	/// There was some other unspecified problem
	case Other(Error)
}
