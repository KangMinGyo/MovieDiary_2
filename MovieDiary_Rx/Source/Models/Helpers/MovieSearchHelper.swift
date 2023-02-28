//
//  MovieSearchHelper.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/26.
//

import Foundation

struct MovieSearchHelper {
    
    func directorNameHelper(_ director: [directors]) -> String {
        if director.isEmpty {
            return "-"
        } else {
            return "\(director[0].peopleNm)"
        }
    }
}
