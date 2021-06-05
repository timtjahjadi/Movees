//
//  Movie.swift
//  Movees
//
//  Created by Timotius Tjahjadi  on 04/06/21.
//

import Foundation

struct MovieResp: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let backdrop_path: String?
    let poster_path: String?
    let overview: String
    let vote_average: Double
    let vote_count: Int
    let release_date: String
}
