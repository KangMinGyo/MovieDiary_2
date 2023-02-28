//
//  MovieReviewViewModel.swift
//  MovieDiary
//
//  Created by KangMingyo on 2023/01/03.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieReviewModelType {
    var reviewMetaDatas: BehaviorRelay<[ReviewMetaData]> { get set }

}

class MovieReviewViewModel: MovieReviewModelType {
    
    var reviewMetaDatas = BehaviorRelay<[ReviewMetaData]>(value: [])

    
}
