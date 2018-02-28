//
//  PeopleViewController+CoreData.swift
//  hellomongo
//
//  Created by Mauricio Leal on 2/28/18.
//  Copyright © 2018 Mauricio Leal. All rights reserved.
//

import CoreData

extension PeopleViewController {
    
    func loadCoreData() {
        // Step 1: Prepare key variables
        let context: NSManagedObjectContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Person> = NSFetchRequest(entityName: "Person")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true),
                    NSSortDescriptor(key: "lastName", ascending: true)]
        
        // Step 2: Create a NSFetchedResultsController instance and attach to a delegate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        // Step 3: Perform Fetch
        do {
            try fetchedResultsController.performFetch()
        } catch let performErr {
            print("### loadCoreData() UNABLE TO PERFORM FETCH:", performErr)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(">>> controllRerWillChangeContent()")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print(">>> controller(didChange)")
        
        switch type {
        // INSERT/CREATE
        case NSFetchedResultsChangeType.insert:
            if let insertIndexPath = newIndexPath {
                tableView.insertRows(at: [insertIndexPath], with: .automatic)
            }
        // DELETE
        case NSFetchedResultsChangeType.delete:
            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: .automatic)
            }
            
        // UPDATE
        case NSFetchedResultsChangeType.update:
            if let updateIndexPath = indexPath {
                let cell = tableView.cellForRow(at: updateIndexPath)
                let person: Person = fetchedResultsController.object(at: updateIndexPath)
                
                if let firstName = person.firstName, let lastName = person.lastName {
                    cell?.textLabel?.text = "\(firstName) \(lastName)"
                }
            }
            
        // MOVE = DELETE + INSERT
        case NSFetchedResultsChangeType.move:
            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: .automatic)
            }
            
            if let insertIndexPath = newIndexPath {
                tableView.insertRows(at: [insertIndexPath], with: .automatic)
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        print(">>> controller(didChange:sectionInfo")
        
        switch type {
        // INSERT
        case .insert:
            let sectionIndexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(sectionIndexSet, with: .automatic)
        // DELETE
        case .delete:
            let sectionIndexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(sectionIndexSet, with: .automatic)
        default:
            break
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(">>> controllerDidChangeContent")
        tableView.endUpdates()
    }
}
