//
//  MovieSearchService.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/12/25.
//

import Foundation
import Alamofire
import RxSwift

protocol MovieFetchable {
    func fetchSearchMovie(movieName: String) -> Observable<[MovieList]>
}

class MovieSearchService: MovieFetchable {
    
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "KeyList", ofType: "plist") else {
                fatalError("Couldn't find KeyList")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "Movie_API_KEY") as? String else {
                fatalError("Couldn't find key 'Movie_API_KEY")
            }
            return value
        }
    }
    
    func fetchSearchMovie(movieName: String) -> Observable<[MovieList]> {
        return Observable.create { (observer) -> Disposable in
            self.fetchSearchMovie(movieName: movieName) { (error, movieData) in
                if let error = error {
                    observer.onError(error)
                }
                if let movieData = movieData {
                    observer.onNext(movieData)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    private func fetchSearchMovie(movieName: String, completion: @escaping((Error?, [MovieList]?) -> Void)) {
        var url = String("https://kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=\(apiKey)&movieNm=\(movieName)")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let searchURL = URL(string: url) else { return completion(NSError(domain: "kang15567", code: 404), nil) }
        
        AF.request(searchURL, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: MovieSearchData.self) { response in
            if let error = response.error {
                return completion(error, nil)
            }
            if let searchDatas = response.value?.movieListResult.movieList {
                return completion(nil, searchDatas)
            }
        }
    }
}
