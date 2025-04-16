//
//  movie.swift
//  MovieExplorer
//
//  Created by Het Shah on 2025-04-16.
//

import Foundation

struct MovieList: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let release_date: String
    let poster_path: String?
}
