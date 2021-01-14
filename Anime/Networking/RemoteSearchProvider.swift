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
	var host: String = "https://anime.rileyw.dev"
	// NOTE: The above URL points to my personal server
	// While working on this, I was never able to reach the provided API (no response / timeout)
	//   so I used Docker to self-host a copy of the API on my personal home server
	// Reading through the documentation of the official API, I noticed mentions of rate-limits
	//   which my self-hosted copy does not have. Hopefully this won't matter.
	// If the original API comes back up and/or for some reason my server is down, the below line
	//   of code *should* switch it to the official API.
	// var host: String = "https://api.jikan.moe"
	
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
			// Apparently the official API only permits 1 request every 4s
			//.throttle(for: .seconds(4.5), scheduler: RunLoop.current, latest: true)
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
