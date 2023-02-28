//
//  ViewMoviePoster.swift
//  MovieDiary
//
//  Created by KangMingyo on 2023/01/18.
//

import Foundation

struct ViewMoviePoster {
    var title: String
    var posterPath : String
    
    init(_ item: Results) {
        title = item.title
        posterPath = item.posterPath
    }
}
