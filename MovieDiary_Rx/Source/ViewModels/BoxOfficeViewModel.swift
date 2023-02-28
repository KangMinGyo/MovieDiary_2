//
//  BoxOfficeViewModel.swift
//  MovieDiary
//
//  Created by KangMingyo on 2023/01/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol BoxOfficeViewModelType {
    
    var boxOfficeItems: BehaviorRelay<[ViewBoxOffice]> { get }
    var moviePosterItems: BehaviorRelay<[ViewMoviePoster]> { get }
    var movieCode: BehaviorRelay<[String]> { get }
    
    func fetchBoxOffice(date: String) -> Observable<[ViewBoxOffice]>
    func fetchMoviePoster(movieNm: String) -> Observable<[ViewMoviePoster]>
    func checkMoviePosterItems(_ items: [ViewMoviePoster]) -> Bool
}

class BoxOfficeViewModel {
    
    let disposeBag = DisposeBag()
    private let domain: BoxOfficeFetchable
    
    let boxOfficeItems = BehaviorRelay<[ViewBoxOffice]>(value: [])
    var moviePosterItems = BehaviorRelay<[ViewMoviePoster]>(value: [])
    var realmMoviePosterItems = BehaviorRelay<[ViewMoviePoster]>(value: [])
    let movieCode = BehaviorRelay<[String]>(value: [])
    
    var posterVaild = BehaviorSubject(value: false)
    
    init(domain: BoxOfficeFetchable) {
        self.domain = domain
        
        bind()
    }

    func bind() {
        moviePosterItems
            .map(checkMoviePosterItems)
            .bind(to: posterVaild)
            .disposed(by: disposeBag)
    }
    
    func fetchBoxOffice(date: String) -> Observable<[ViewBoxOffice]> {
        domain.fetchBoxOfficeData(date: date)
            .map { $0.map { ViewBoxOffice($0) } }
    }
    
    func fetchMoviePoster(movieNm: String) -> Observable<[ViewMoviePoster]> {
        domain.fetchMoviePosterData(movieName: movieNm)
            .map { $0.map { ViewMoviePoster($0) } }
    }
    
    func checkMoviePosterItems(_ items: [ViewMoviePoster]) -> Bool {
        return items.count > 9
    }
}
