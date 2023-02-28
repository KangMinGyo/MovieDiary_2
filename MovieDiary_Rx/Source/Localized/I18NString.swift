//
//  I18NString.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/11/24.
//

import Foundation

struct I18NString {
    struct Title {
        static let reviewList = "reviewList".localized
        static let movieSearchTitle = "movieSearchTitle".localized
        static let boxOfficeTitle = "boxOfficeTitle".localized
        static let setting = "settings".localized
    }
    
    struct SubTitle {
        static let myReview = "myReview".localized
        static let myRate = "myRate".localized
        static let actionSheet = "actionSheet".localized
    }
    
    struct Button {
        static let saveButton = "saveButton".localized
    }
    
    struct Explanation {
        static let searchBar = "searchBar".localized
        static let reviewView = "reviewView".localized
        static let rateButton = "rateButton".localized
    }
    
    struct Alert {
        static let contentsTitle = "contentsTitle".localized
        static let contensMessage = "contensMessage".localized
        static let contensMessage2 = "contensMessage2".localized
    }
    
    struct actionSheet {
        static let best = "best".localized
        static let good = "good".localized
        static let notbad = "notbad".localized
        static let bad = "bad".localized
    }
    
    struct mail {
        static let feedback = "Feedback".localized
    }
}
