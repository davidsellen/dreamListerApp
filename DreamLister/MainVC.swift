//
//  MainVC.swift
//  DreamLister
//
//  Created by David Santos on 10/05/17.
//  Copyright © 2017 dscode. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController , UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        genTestData()
        attemptFetch()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell : ItemCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    
    func attemptFetch() {
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        self.controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try self.controller.performFetch()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete :
            
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func genTestData() {
        
        if isNotEmpty {
           return
        }
        
        let item1 = Item.init(entity: NSEntityDescription.entity(forEntityName: "Item", in:context)!, insertInto: context)
        item1.title = "Macbook PRO"
        item1.price = 2500
        item1.details = "This is so cool, and you can create code on it. Can't wait until I get mine."
        item1.created = NSDate()
        
        let item2 = Item.init(entity: NSEntityDescription.entity(forEntityName: "Item", in:context)!, insertInto: context)
        item2.title = "Bose headphone"
        item2.price = 300
        item2.details = "Can't wait til I get mine so I can blockout people talking around."
        
        let item3 = Item.init(entity: NSEntityDescription.entity(forEntityName: "Item", in:context)!, insertInto: context)
        item3.title = "Tesla model S"
        item3.price = 110000
        item3.details = "This is the dream car, someday I'll own it."
        ad.saveContext()
        
    }
    
    var isNotEmpty : Bool {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
            let count  = try context.count(for: request)
            return count > 0
        }catch let err as NSError{
            print(err.debugDescription)
            return true
        }
    }
    
}
