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
	private var host: String = "https://api.jikan.moe"
	
	/// An alternate remote API host
	private var alternateHost: String = "https://anime.rileyw.dev"
	
	/// Path relative to host for searching
	private var searchPath: String { "/v3/search/anime" }
	
	/// Obtains a list of animes
	/// - Parameter keyword: keyword to search for
	/// - Returns: An array of animes, sorted by relevance
	func search(keyword: String) -> AnyPublisher<[Anime], SearchError> {
		
		guard keyword.count >= 3,
			  let encodedKeywords = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
			  let url = URL(string: host + searchPath + "?q=\(encodedKeywords)")
		else {
			return Just([])
				.setFailureType(to: SearchError.self)
				.eraseToAnyPublisher()
		}
		
		let backgroundQueue = DispatchQueue.global()
		
		return URLSession.shared.dataTaskPublisher(for: url)
			.timeout(.seconds(3), scheduler: backgroundQueue, customError: { URLError(.timedOut) })
			.tryCatch { [weak self] _ -> URLSession.DataTaskPublisher in
				guard let self = self,
					  let alternateURL = URL(string: self.alternateHost + self.searchPath + "?q=\(encodedKeywords)") else { throw URLError(.cannotConnectToHost) }
				//Switch hosts because the issue is likely to persist
				let tmp = self.host
				self.host = self.alternateHost
				self.alternateHost = tmp
				return URLSession.shared.dataTaskPublisher(for: alternateURL)
			}
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
				
			}.subscribe(on: backgroundQueue)
			.eraseToAnyPublisher()
	}
	
}
