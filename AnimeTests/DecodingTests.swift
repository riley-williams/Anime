//
//  DecodingTests.swift
//  AnimeTests
//
//  Created by Riley Williams on 1/13/21.
//

import XCTest
import Combine
@testable import Anime

class DecodingTests: XCTestCase {

	private var cancellables: Set<AnyCancellable> = []
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testNetworkedSearchResults() throws {
		let expectResponse = expectation(description: "Response recieved from server")
		
		
		
		RemoteSearchProvider()
			.search(keyword: "Naruto")
			.sink { completion in
				switch completion {
				case .failure(let err):
					switch err {
					case .DecodingError:
						XCTFail("Failed to decode response")
					case .Unresponsive:
						XCTFail("Failed to reach the target server")
					case .Other(_):
						XCTFail("Failed due to unspecified network error")
					}
				case .finished:
					break
				}
				expectResponse.fulfill()
			} receiveValue: { results in
				XCTAssertGreaterThan(results.count, 0, "Expected more than 0 results")
			}.store(in: &cancellables)
		
		waitForExpectations(timeout: 15, handler: nil)
		
    }
	
	func testDecodeSearchResults() throws {
		let testResponse = """
{
    "request_hash": "request:search:75c73ad949684967318c3d661178c9ec45bf66bd",
    "request_cached": false,
    "request_cache_expiry": 1000,
    "results": [
        {
            "mal_id": 16498,
            "url": "https://myanimelist.net/anime/16498/Shingeki_no_Kyojin",
            "image_url": "https://cdn.myanimelist.net/images/anime/10/47347.jpg?s=29949c6e892df123f0b0563e836d3d98",
            "title": "Shingeki no Kyojin",
            "airing": false,
            "synopsis": "Centuries ago, mankind was slaughtered to near extinction by monstrous humanoid creatures called titans, forcing humans to hide in fear behind enormous concentric walls. What makes these giants truly...",
            "type": "TV",
            "episodes": 25,
            "score": 8.47,
            "start_date": "2013-04-07T00:00:00+00:00",
            "end_date": "2013-09-29T00:00:00+00:00",
            "members": 2357843,
            "rated": "R"
        },
        {
            "mal_id": 25777,
            "url": "https://myanimelist.net/anime/25777/Shingeki_no_Kyojin_Season_2",
            "image_url": "https://cdn.myanimelist.net/images/anime/4/84177.jpg?s=74f2f396ab23eee08691546aaa2c6fad",
            "title": "Shingeki no Kyojin Season 2",
            "airing": false,
            "synopsis": "For centuries, humanity has been hunted by giant, mysterious predators known as the Titans. Three mighty walls—Wall Maria, Rose, and Sheena—provided peace and protection for humanity for over a hundre...",
            "type": "TV",
            "episodes": 12,
            "score": 8.43,
            "start_date": "2017-04-01T00:00:00+00:00",
            "end_date": "2017-06-17T00:00:00+00:00",
            "members": 1449858,
            "rated": "R"
        }
    ],
    "last_page": 20
}
""".data(using: .utf8)!
		
		guard let decodedResponse = try? JSONDecoder().decode(SearchResponse.self, from: testResponse)
		else {
			XCTFail("Failed to decode sample response")
			return
		}
		
		XCTAssertEqual(decodedResponse.results.count, 2, "Expected 2 results in response")
		
	}
	
	func testDecodeAnimeModel() throws {
		let testResponse = """
{
	"mal_id": 16498,
	"url": "https://myanimelist.net/anime/16498/Shingeki_no_Kyojin",
	"image_url": "https://cdn.myanimelist.net/images/anime/10/47347.jpg?s=29949c6e892df123f0b0563e836d3d98",
	"title": "Shingeki no Kyojin",
	"airing": false,
	"synopsis": "Centuries ago, mankind was slaughtered to near extinction by monstrous humanoid creatures called titans, forcing humans to hide in fear behind enormous concentric walls. What makes these giants truly...",
	"type": "TV",
	"episodes": 25,
	"score": 8.47,
	"start_date": "2013-04-07T00:00:00+00:00",
	"end_date": "2013-09-29T00:00:00+00:00",
	"members": 2357843,
	"rated": "R"
}
""".data(using: .ascii)!
		
		guard let decodedResponse = try? JSONDecoder().decode(Anime.self, from: testResponse)
		else {
			XCTFail("Failed to decode sample result")
			return
		}
		
		XCTAssertEqual(decodedResponse.title, "Shingeki no Kyojin", "Expected a different title")
		
	}

}
