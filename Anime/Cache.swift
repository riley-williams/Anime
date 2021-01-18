//
//  Cache.swift
//  Anime
//
//  Created by Riley Williams on 1/18/21.
//

import UIKit

/// A very simple cache
class Cache<Key: Hashable, Element> {

	/// Cache of images
	private var cache = [Key: Element]()
	
	/// Maximum number of items to keep
	var cacheSize: Int = 100 {
		didSet { reclaimSpace() }
	}
	
	/// Ejects items in a dumb way
	private func reclaimSpace() {
		while cache.count > cacheSize {
			//eject old items
			if let first = cache.keys.first {
				cache[first] = nil
			}
		}
	}
	
	subscript(key: Key) -> Element? {
		get {
			return cache[key]
		}
		set {
			cache[key] = newValue
			reclaimSpace()
		}
	}

}
