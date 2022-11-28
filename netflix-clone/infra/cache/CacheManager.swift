//
//  CacheManager.swift
//  netflix-clone
//
//  Created by Rony on 25/11/22.
//

import Foundation
import UIKit
import CoreData

class CacheManager {
    static let shared = CacheManager()
    
    func saveTitle(_ title: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let titleEntities = try context.fetch(TitleEntity.fetchRequest())
            guard titleEntities.first(where: { entity in return entity.id == title.id }) == nil else {
                return completion(.success(()))
            }
        } catch {
            return completion(.failure(Error.failedToCacheData()))
        }
        
        let titleEntity = TitleEntity(context: context)
        titleEntity.id = Int64(title.id)
        titleEntity.name = title.name
        titleEntity.posterPath = title.posterPath
        titleEntity.type = Int64(title.type.rawValue)
        titleEntity.overview = title.overview
        titleEntity.isAdult = title.isAdult
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(Error.failedToCacheData()))
        }
    }
    
    func fetchTitles(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let request = TitleEntity.fetchRequest()
        
        do {
            let titleEntityList = try context.fetch(request)
            completion(.success(titleEntityList.map({
                entity in Title(
                    id: Int(entity.id),
                    name: entity.name!,
                    posterPath: entity.posterPath!,
                    type: TitleType(rawValue: Int(entity.type))!,
                    overview: entity.overview!,
                    isAdult: entity.isAdult
                )}
           )))
        } catch {
            completion(.failure(Error.failedToCacheData()))
        }
    }
    
    func deleteTitle(with title: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext

        do {
            let titleEntities = try context.fetch(TitleEntity.fetchRequest())
            guard let titleEntity = titleEntities.first(where: { entity in return entity.id == title.id }) else {
                return
            }

            context.delete(titleEntity)
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(Error.failedToDeleteCachedData()))
        }
    }
}
