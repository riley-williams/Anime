//
//  RemoteSearchProvider.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import Combine
import Foundation

class RemoteSearchProvider: AnimeSearchProvider {
	/// The remote API host
	var host: String = "http://192.168.1.5:59001"
	
	
	/// Obtains a list of animes
	/// - Parameter keyword: keyword to search for
	/// - Returns: An array of animes, sorted by relevance
	func search(keyword: String) -> AnyPublisher<[Anime], SearchError> {
		
		guard keyword.count >= 3,
			  let encodedKeywords = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
			  let url = URL(string: host + "/v3/search/anime?q=\(encodedKeywords)")
		else {
			return Just([])
				.setFailureType(to: SearchError.self)
				.eraseToAnyPublisher()
		}
		
		return URLSession.shared.dataTaskPublisher(for: url)
			.timeout(.seconds(1), scheduler: DispatchQueue.global())
			.map(\.data)
			.decode(type: SearchResponse.self, decoder: JSONDecoder())
			.map(\.results)
			.mapError { error in
				print(error)
				switch error {
				case is URLError:
					return .Unresponsive
				case is DecodingError:
					return .DecodingError
				default:
					return .Other(error)
				}
				
			}.eraseToAnyPublisher()
	}
	
}
