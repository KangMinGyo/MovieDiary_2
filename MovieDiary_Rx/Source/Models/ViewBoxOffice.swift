//
//  ViewBoxOffice.swift
//  MovieDiary
//
//  Created by KangMingyo on 2023/01/16.
//

import Foundation

struct ViewBoxOffice {
    
    var rank: String
    var rankInten: String
    var movieNm: String
    var openDt: String
    var audiAcc: String
    var movieCd: String
    
    init(_ item: DailyBoxOfficeList) {
        rank = item.rank
        rankInten = item.rankInten
        movieNm = item.movieNm
        openDt = item.openDt
        audiAcc = item.audiAcc
        movieCd = item.movieCd
    }
    
}
