//
//  Movies.swift
//  Rentflix
//
//  Created by Guo Tian on 2/19/21.
//

import Foundation

struct Results: Codable {
    var results: [Movies]
}

struct Movies:Codable, Hashable {
//    var trackId: Int?
    var trackName: String?
    var contentAdvisoryRating: String?
    var trackPrice: Float?
    var longDescription: String?
    var artworkUrl100: String?
    var previewUrl: String?
}
