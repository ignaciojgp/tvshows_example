//
//  CoreDataServiceImpl.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit
import CoreData

class LocalDataServiceImpl: NSObject , LocalDataService{
    lazy var _persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "tv_shows")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getPersistentContainer() -> NSPersistentContainer {
        return _persistentContainer;
    }
    
    func save() {
        let context = _persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    

}
