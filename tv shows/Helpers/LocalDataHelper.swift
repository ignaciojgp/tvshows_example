//
//  CoreDataServiceImpl.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit
import CoreData

public enum LocalEntity:String{
    case tvShow = "FavoriteTVShow"
}

enum LocalDataHelperError: Error {
    case emptyList
    case missingData
    case unexpected
}



public class LocalDataHelper: NSObject {
    
    static let CONTAINER_NAME = "tv_shows"

    
    lazy var _persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: LocalDataHelper.CONTAINER_NAME)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// returns the persistent container for the app
    func getPersistentContainer() -> NSPersistentContainer {
        return _persistentContainer;
    }
    
    //returns the context for coredata
    func getContext()->NSManagedObjectContext{
        return _persistentContainer.viewContext
    }
    
    ///create a new object to be saved
    public func createObject(name:LocalEntity)->NSManagedObject{
        let entityDescription = NSEntityDescription.entity(forEntityName: name.rawValue, in: _persistentContainer.viewContext)!
        return NSManagedObject(entity: entityDescription, insertInto: getContext())

    }
    
    
    ///returns all data for a type of
    public func getEntityList(name:LocalEntity) -> [NSManagedObject]?{
        
            
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name.rawValue)
        do {
            let list =  try self.getContext().fetch(fetchRequest)
            
            return list
            
        } catch let error as NSError {
            
            debugPrint(error)
            return nil
        }
        
        
        
    }
    
    ///returns an stored object data by id
    public func getEntity(name:LocalEntity, by id:Int64) ->NSManagedObject? {
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        do {
            let list =  try self.getContext().fetch(fetchRequest)
            if(list.count > 0){
                return list.first
            }else{
                return nil
            }
            
        } catch let error as NSError {
            debugPrint(error)
            return nil
        }
            
    }
    
    
    ///delete an object with id
    public func deleteEntity(name:LocalEntity, by id:Int64) ->Int? {
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        do {
            let list =  try self.getContext().fetch(fetchRequest)
            if(list.count > 0){
                
                list.forEach { (object) in
                    self.getContext().delete(object)
                }
                
                return list.count
                
                
            }else{
                return 0
            }
            
        } catch let error as NSError {
            debugPrint(error)
            return 0
        }
            
    }
    
    ///delete all data for a type of
    public func deleteAll(name:LocalEntity) -> Int{
        
            
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name.rawValue)
        do {
            let list =  try self.getContext().fetch(fetchRequest)

            list.forEach { (object) in
                getContext().delete(object)
            }
            
            return list.count
            
        } catch let error as NSError {
            
            debugPrint(error)
            return 0
        }
        
    }
    
    
    ///save the database
    public func save() throws {
        let context = _persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw LocalDataHelperError.missingData
            }
        }
    }
    

}
