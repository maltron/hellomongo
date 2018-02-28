//
//  PeopleViewController+TableView.swift
//  hellomongo
//
//  Created by Mauricio Leal on 2/28/18.
//  Copyright © 2018 Mauricio Leal. All rights reserved.
//

import UIKit
import CoreData

extension PeopleViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections: [NSFetchedResultsSectionInfo] = fetchedResultsController.sections else { return 0 }
        
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "peoplecell", for: indexPath)
        let person: Person = fetchedResultsController.object(at: indexPath)
        
        if let firstName = person.firstName, let lastName = person.lastName {
            cell.textLabel?.text = "\(firstName) \(lastName)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction: UITableViewRowAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let context: NSManagedObjectContext = self.persistentContainer.viewContext
            let person: Person = self.fetchedResultsController.object(at: indexPath)
            
            context.delete(person)
            do {
                try context.save()
            } catch let deleteErr {
                print("### tableView(_,editActionsForRowAt:) UNABLE TO DELETE DATA:", deleteErr)
            }
        }
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personViewController: PersonViewController = PersonViewController()
        personViewController.person = fetchedResultsController.object(at: indexPath)
        personViewController.delegate = self
        
        navigationController?.pushViewController(personViewController, animated: true)
    }
}
