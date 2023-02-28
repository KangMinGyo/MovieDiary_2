//
//  MovieSearch.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/25.
//

import Foundation

struct MovieSearchData : Codable {
    let movieListResult : MovieListResult
}

struct MovieListResult : Codable {
    let movieList : [MovieList]
}

struct MovieList : Codable {
    let movieNm: String
    let movieNmEn: String
    let prdtYear: String //개봉년도
    let nationAlt: String //제작국가
    let genreAlt: String // 장르
    let directors: [directors]
    
    var movieInfo: String {
        return String(nationAlt + " | " + genreAlt + " | " + prdtYear)
    }
}

struct directors : Codable {
    let peopleNm: String
}
