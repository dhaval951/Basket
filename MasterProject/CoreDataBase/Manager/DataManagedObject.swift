//
//  DataManagedObject.swift
//  MasterProject
//
//  Created by Sanjay Shah on 09/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import CoreData

//MARK: - NSManagedObject

extension NSManagedObject {
    
    class func entityName() -> String {
        return "\(classForCoder())"
    }
}

//MARK: - Protocol ParentManagedObject
protocol DataManagedObject {
    
}

extension DataManagedObject where Self: NSManagedObject {
    
    /***
     It will create a new entity in database by passing its name and return NSManagedObject
     */
    static func createNewEntity() -> Self {
        let context: NSManagedObjectContext!
        
        if #available(iOS 10.0, *) {
            context = appDelegate.persistentContainer.viewContext
        } else {
            
            context = appDelegate.managedObjectContext
            // Fallback on earlier versions
        }
        
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName(), into: context) as! Self

        return object
    }
    
    
    /***
     It will return existing entity or will send band new entity
     */
    static func createNewEntity(_ key: String,value:String) -> Self {
        let predicate = NSPredicate(format: "%K = %@", key, value)
        let results = fetchDataFromEntity(predicate, sortDescs: nil)
        let entity: Self
        if results.isEmpty{
            entity = createNewEntity()
        }else{
            entity = results.first!
        }
        return entity
    }
    
    /***
     It will return existing entity with combination of key and value or will send band new entity
     */
    static func createNewEntity(_ keys:[String], values:[String]) -> Self {
        var conditions:[NSPredicate] = []
        for (index,key) in keys.enumerated() {
            conditions.append(NSPredicate(format: "%K = %@", key, values[index]))
        }
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: conditions)
        let results = fetchDataFromEntity(predicate, sortDescs: nil)
        let entity: Self
        if results.isEmpty{
            entity = createNewEntity()
        }else{
            entity = results.first!
        }
        return entity
    }
    
    /***
     It will only check for given primary key entiry and if presenet in database will return it
     */
    static func checkForEntity(_ key: String, value: NSString) -> Self? {
        let predicate = NSPredicate(format: "%K = %@", key, value)
        let results = fetchDataFromEntity(predicate, sortDescs: nil)
        if results.isEmpty {
            return nil
        } else {
            return results.first!
        }
    }
    
    
    /***
     It will return NSEntityDescription optional value, by passing entity name.
     */
    static func getExisting() -> NSEntityDescription? {
        
        let context: NSManagedObjectContext!
        
        if #available(iOS 10.0, *) {
            context = appDelegate.persistentContainer.viewContext
        } else {
            
            context = appDelegate.managedObjectContext
            // Fallback on earlier versions
        }
        
        let entityDesc = NSEntityDescription.entity(forEntityName: entityName(), in: context)
        
        return entityDesc
    }
    
    /***
     It will return an array of existing values from given entity name, with peredicate and sort description.
     */
    static func fetchDataFromEntity(_ predicate:NSPredicate?, sortDescs:NSArray?)-> [Self] {
        let entityDesc = getExisting()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDesc
        
        if let _ = predicate {
            fetchRequest.predicate = predicate
        }
        if let _ = sortDescs {
            fetchRequest.sortDescriptors = sortDescs as? Array
        }
        
        do {
            let context: NSManagedObjectContext!
            
            if #available(iOS 10.0, *) {
                context = appDelegate.persistentContainer.viewContext
            } else {
                
                context = appDelegate.managedObjectContext
                // Fallback on earlier versions
            }

            let resultsObj = try context.fetch(fetchRequest)

            if (resultsObj as! [Self]).count > 0 {
                return resultsObj as! [Self]
            }else{
                return []
            }
        } catch let error as NSError {
            print("Error in fetchedRequest : \(error.localizedDescription)")
            return []
        }
    }
    
    // This will only bring single entity of given predicate if it exist in db. No need to pass sort descriptor here.
    static func fetchSingleDataFromEntity(_ predicate:NSPredicate?)-> Self? {
        let entityDesc = getExisting()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDesc
        
        if let _ = predicate {
            fetchRequest.predicate = predicate
        }
        
        do {
            let context: NSManagedObjectContext!
            
            if #available(iOS 10.0, *) {
                context = appDelegate.persistentContainer.viewContext
            } else {
                
                context = appDelegate.managedObjectContext
                // Fallback on earlier versions
            }
            
            let resultsObj = try context.fetch(fetchRequest)
            
            if (resultsObj as! [Self]).count > 0 {
                return resultsObj[0] as? Self
            }else{
                return nil
            }
        } catch let error as NSError {
            print("Error in fetchedRequest : \(error.localizedDescription)")
            return nil
        }
    }
}
