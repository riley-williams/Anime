//
//  SearchResponse.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import Foundation

/// Simply wraps the results of a search for an anime
struct SearchResponse: Codable {
	/// Results returned by the search
	var results: [Anime]
}
