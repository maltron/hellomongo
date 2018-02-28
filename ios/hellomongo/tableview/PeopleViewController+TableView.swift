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
    
}
