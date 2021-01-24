//
//  CoreDataService.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit
import CoreData

protocol LocalDataService{
    func getPersistentContainer()-> NSPersistentContainer;
    func save()
}
