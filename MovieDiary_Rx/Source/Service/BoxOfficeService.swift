//
//  MovieDataService.swift
//  BoxOffice
//
//  Created by KangMingyo on 2022/10/18.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkError: Error {
    case badUrl
}

protocol BoxOfficeFetchable {
    func fetchBoxOfficeData(date: String) -> Observable<[DailyBoxOfficeList]>
    
    func fetchMoviePosterData(movieName: String) -> Observable<[Results]>
}

class BoxOfficeService: BoxOfficeFetchable {
    
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
    
    private var posterApiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "KeyList", ofType: "plist") else {
                fatalError("Couldn't find KeyList")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "Poster_API_KEY") as? String else {
                fatalError("Couldn't find key 'Poster_API_KEY")
            }
            return value
        }
    }
    
    // MARK: - BoxOfficeData
    
    func fetchBoxOfficeData(date: String) -> Observable<[DailyBoxOfficeList]> {
        return Observable.create { (observer) -> Disposable in
            self.fetchBoxOfficeData(date: date) { (error, boxOfficeData) in
                if let error = error {
                    observer.onError(error)
                }
                if let boxOfficeData = boxOfficeData {
                    observer.onNext(boxOfficeData)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    private func fetchBoxOfficeData(date: String, completion: @escaping((Error?, [DailyBoxOfficeList]?) -> Void)) {
        var url = String("https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(apiKey)&targetDt=\(date)")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let boxOfficeURL = URL(string: url) else { return completion(NSError(domain: "kang15567", code: 404), nil) }
        
        AF.request(boxOfficeURL, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: BoxOfficeData.self) { response in
            if let error = response.error {
                return completion(error, nil)
            }
            if let boxOfficeDatas = response.value?.boxOfficeResult.dailyBoxOfficeList {
                return completion(nil, boxOfficeDatas)
            }
        }
    }
    
    // MARK: - MoviePosterData
    
    func fetchMoviePosterData(movieName: String) -> Observable<[Results]> {
        return Observable.create { (observer) -> Disposable in
            self.fetchMoviePosterData(movieName: movieName) { (error, moviePosterData) in
                if let error = error {
                    observer.onError(error)
                }
                if let moviePosterData = moviePosterData {
                    observer.onNext(moviePosterData)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    private func fetchMoviePosterData(movieName: String, completion: @escaping((Error?, [Results]?) -> Void)) {
        var url = String("https://api.themoviedb.org/3/search/movie?api_key=\(posterApiKey)&language=ko&page=1&include_adult=false&region=KR&query=\(movieName)")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let posterURL = URL(string: url) else { return completion(NSError(domain: "kang15567", code: 404), nil) }
        
        AF.request(posterURL, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: MoviePosterData.self) { response in
            if let error = response.error {
                return completion(error, nil)
            }
            if let moviePosterData = response.value?.results {
                return completion(nil, moviePosterData)
            }
        }
    }
}
