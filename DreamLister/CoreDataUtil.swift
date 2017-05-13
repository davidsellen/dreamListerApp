//
//  CoreDataUtil.swift
//  DreamLister
//
//  Created by David Santos on 12/05/17.
//  Copyright © 2017 dscode. All rights reserved.
//



import Foundation
import CoreData

class CoreDataUtil {

static func isNotEmpty (entityName: String) -> Bool {
    do{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let count  = try context.count(for: request)
        return count > 0
    }catch let err as NSError{
        print(err.debugDescription)
        return true
    }
}

}
