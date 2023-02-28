//
//  MoviePosterData.swift
//  BoxOffice
//
//  Created by KangMingyo on 2022/10/20.
//

import Foundation

struct MoviePosterData: Codable {
    let results : [Results]
}

struct Results: Codable {
    let title: String
    let poster_path : String?
    
    var posterPath: String {
        return String("https://image.tmdb.org/t/p/original" + (poster_path ?? "https://image.tmdb.org/t/p/original"))
    }
}
