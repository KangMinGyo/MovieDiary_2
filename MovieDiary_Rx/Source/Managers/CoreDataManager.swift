//
//  CoreDataManger.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/27.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    
    /// CoreData에 리뷰목록을 요청합니다.
    func fetchReviewMataData(start: Int) throws -> [ReviewMetaData]
    
    /// CoreData와 상호작용할 수 있는 ReviewMetaData 객체를 요청합니다.
    func createNewReview(title: String, contents: String, movieInfo: String, eval: String) throws -> ReviewMetaData
    
    /// CoreData에 새 레코드 생성을 요청합니다.
    func insertReviewMataData(_ data: ReviewMetaData) throws
    
    /// CoreData에서 특정 레코드의 삭제를 요청합니다.
    func deleteReviewMetaData(_ data: ReviewMetaData) throws
    
}

class CoreDataManager: CoreDataManagerProtocol {

    static let shared = CoreDataManager()
    private init() { }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDiary_Rx")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchReviewMataData(start: Int) throws -> [ReviewMetaData] {
        let request = ReviewMetaData.fetchRequest()
        let sortByDateDesc = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        let result = try self.context.fetch(request)
        return result
    }
    
    func createNewReview(title: String, contents: String, movieInfo: String, eval: String) throws -> ReviewMetaData {
        let metadata = ReviewMetaData(context: context)
        metadata.contents = contents
        metadata.date = Date()
        metadata.title = title
        metadata.movieInfo = movieInfo
        metadata.eval = eval
        return metadata
    }
    
    func insertReviewMataData(_ data: ReviewMetaData) throws {
        try self.context.save()
    }
    
    func deleteReviewMetaData(_ data: ReviewMetaData) throws {
        self.context.delete(data)
        try self.context.save()
    }
}

