//
//  ViewMovie.swift
//  MovieDiary
//
//  Created by KangMingyo on 2023/01/02.
//

import Foundation

struct ViewMovie {

    var movieNm: String
    var movieNmEn: String
    var info: String
    var genre: String
    var nation: String
    var year: String
    var directorNm: [directors]


    init(_ item: MovieList) {
        movieNm = item.movieNm
        movieNmEn = item.movieNmEn
        info = item.movieInfo
        genre = item.genreAlt
        nation = item.nationAlt
        year = item.prdtYear
        directorNm = item.directors
    }
}
