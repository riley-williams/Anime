//
//  Anime.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import Foundation

/// Model object containing information about an anime show/film
struct Anime: Codable {
	/// Unique ID assigned by MyAnimeList
	var id: Int
	/// MyAnimeList URL
	var url: String
	/// Cover art URL
	var imageURL: String?
	/// Name of the anime
	var title: String
	/// Bool indicating whether this show is still airing
	var isAiring: Bool?
	/// Short truncated description
	var synopsis: String?
	/// Anime type. e.g. TV, Special, etc.
	var type: String
	/// Number of episodes
	var episodeCount: Int?
	/// Reviewer score 0.0 - 10.0
	var score: Float?
	/// Initial air date
	var airDate: String?
	/// Date of last episode
	var endDate: String?
	/// Number of reviewers?
	var members: Int
	/// MPAA film rating
	var rating: String?
	
	enum CodingKeys: String, CodingKey {
		case id = "mal_id"
		case url
		case imageURL = "image_url"
		case title
		case isAiring = "airing"
		case synopsis
		case type
		case episodeCount = "episodes"
		case score
		case airDate = "start_date"
		case endDate = "end_date"
		case members
		case rating = "rated"
	}
}

// Extension to allow easy use of this model in ForEach views
extension Anime: Hashable, Identifiable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
