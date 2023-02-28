//
//  MovieReviewDetailView.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/28.
//

import UIKit
import RxSwift
import RxCocoa

protocol ReviewDetailViewModelType {
    var movieNameText: Observable<String> { get }
    var movieReviewText: Observable<String> { get }
    var movieEvalText: Observable<String> { get }
}

class MovieReviewDetailViewModel: ReviewDetailViewModelType {

    let movieNameText: Observable<String>
    let movieReviewText: Observable<String>
    var movieEvalText: Observable<String>
    
    init(_ selectedReview: ReviewMetaData) {
        let selectedReview = Observable.just(selectedReview)
        
        movieNameText = selectedReview
            .map { $0.title ?? "정보없음" }
        
        movieReviewText = selectedReview
            .map { $0.contents ?? "정보없음" }
        
        movieEvalText = selectedReview
            .map { $0.eval ?? "정보없음" }
    }
}

