//
//  ReviewWriteViewModel.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/12/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReviewWriteViewModelType {
    
    var movieNameText: Observable<String> { get }
    var movieInfoText: Observable<String> { get }
    var reviewInputText: BehaviorRelay<String> { get }
    var evalInputText: BehaviorRelay<String> { get set }
    
    var reviewVaild: BehaviorSubject<Bool> { get set }
    var evalVaild: BehaviorSubject<Bool> { get set }
    
    
    func checkReviewVaild(_ review: String) -> Bool
    func checkEvalVaild(_ eval: String) -> Bool
    func bindInput()
}

class ReviewWriteViewModel: ReviewWriteViewModelType {
    
    let movieNameText: Observable<String>
    let movieInfoText: Observable<String>
    
    var reviewInputText = BehaviorRelay<String>(value: "")
    var evalInputText = BehaviorRelay<String>(value: "")
    var reviewVaild = BehaviorSubject(value: false)
    var evalVaild = BehaviorSubject(value: false)

    
    init(_ selectedMovie: ViewMovie) {
        let selectedMovie = Observable.just(selectedMovie)
        
        movieNameText = selectedMovie
            .map { $0.movieNm }
        
        movieInfoText = selectedMovie
            .map { $0.info }
        
        bindInput()
    }
    
    let disposeBag = DisposeBag()
    
    
    func bindInput() {
        
        reviewInputText
            .map(checkReviewVaild)
            .bind(to: reviewVaild)
            .disposed(by: disposeBag)

        evalInputText
            .map(checkEvalVaild)
            .bind(to: evalVaild)
            .disposed(by: disposeBag)
    }
    
    func checkReviewVaild(_ review: String) -> Bool {
        return review != "내용을 입력해주세요." && review != "Please enter your review" && review.count > 0
    }
    
    func checkEvalVaild(_ eval: String) -> Bool {
        return eval.count > 0
    }
}
