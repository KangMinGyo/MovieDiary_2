//
//  ReviewManager.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/28.
//

import Foundation

protocol ReviewManagerProtocol {
    
    ///Review 저장을 요청합니다.
    func saveReview(title: String, contents: String, movieInfo: String, eval: String, completion: @escaping (Result<ReviewMetaData, Error>) -> ())
    
    ///저장된 리뷰의 목록을 요청합니다.
    func loadReviews(start: Int, completion: @escaping (Result<[ReviewMetaData], Error>) -> ())
    
    ///저장된 리뷰의 삭제를 요청합니다.
    func deleteReview(data: ReviewMetaData, completion: @escaping (Result<Void, Error>) -> ())

}

class ReviewManager: ReviewManagerProtocol {
    
    static let shared = ReviewManager()
    
    private init() { }
    
    func saveReview(title: String, contents: String, movieInfo: String, eval: String, completion: @escaping (Result<ReviewMetaData, Error>) -> ()) {
        DispatchQueue.global().async {
            do {
                let metaData = try CoreDataManager.shared.createNewReview(
                    title: title,
                    contents: contents,
                    movieInfo: movieInfo,
                    eval: eval)
                try CoreDataManager.shared.insertReviewMataData(metaData)
                DispatchQueue.main.async {
                    completion(.success(metaData))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadReviews(start: Int, completion: @escaping (Result<[ReviewMetaData], Error>) -> ()) {
        DispatchQueue.global().async {
            do {
                let metaDatas = try CoreDataManager.shared.fetchReviewMataData(start: start)
                DispatchQueue.main.async {
                    completion(.success(metaDatas))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteReview(data: ReviewMetaData, completion: @escaping (Result<Void, Error>) -> ()) {
        DispatchQueue.global().async {
            do {
                try CoreDataManager.shared.deleteReviewMetaData(data)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
