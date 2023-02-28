//
//  MovieSearchViewModel.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/12/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieSearchViewModelType {
    
    var movieItems: BehaviorRelay<[ViewMovie]> { get }
    
    func fetchMovieSearch(movieName: String) -> Observable<[ViewMovie]>
}

class MovieSearchViewModel {
 
    private let domain: MovieFetchable

    let movieItems = BehaviorRelay<[ViewMovie]>(value: [])
    
    init(domain: MovieFetchable) {
        self.domain = domain
    }

    func fetchMovieSearch(movieName: String) -> Observable<[ViewMovie]> {
        domain.fetchSearchMovie(movieName: movieName)
            .map { $0.map { ViewMovie($0) } }
    }
}
