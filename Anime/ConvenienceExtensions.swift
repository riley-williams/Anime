//
//  ConvenienceExtensions.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import Foundation
import Combine

extension Collection where Element: Cancellable {
	/// Cancels all publishers stored in this collection
	func cancelAll() {
		forEach { $0.cancel() }
	}
}

extension String {
	func toDateISO() -> Date? {
		let dateFormatter = ISO8601DateFormatter()
		return dateFormatter.date(from:self)
	}
}

extension Date {
	var year: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		return dateFormatter.string(from: self)
	}
}
