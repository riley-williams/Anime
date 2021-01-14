//
//  SearchViewModel.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
	@Published var keyword: String = ""
	@Published var results: [Anime] = []
	@Published var message: String?
	
	private var searchProvider: AnimeSearchProvider = RemoteSearchProvider()
	private var cancellables: Set<AnyCancellable> = []
	
	init() {
		// Schedule lookups every time the keyword changes, debounced to 1 second after the last keypress
		$keyword.debounce(for: .seconds(1), scheduler: DispatchQueue.global())
			.flatMap { keyword -> AnyPublisher<[Anime], Never> in
				DispatchQueue.main.sync {
					self.message = nil
					self.results = []
				}
				
				return self.searchProvider.search(keyword:keyword)
					.receive(on: RunLoop.main)
					.mapError { error -> SearchError in
						switch error {
						case .Unresponsive:
							self.message = "Server is unresponsive"
						case .DecodingError:
							self.message = "Unable to decode response"
						case .Other(_):
							self.message = "Unknown error loading results"
						}
						self.results = []
						return error
					}.replaceError(with: [])
					.eraseToAnyPublisher()
			}.assign(to: \.results, on: self)
			.store(in: &cancellables)
	}
}
