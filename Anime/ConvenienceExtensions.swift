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
