//
//  PersonViewController.swift
//  hellomongo
//
//  Created by Mauricio Leal on 2/27/18.
//  Copyright © 2018 Mauricio Leal. All rights reserved.
//

import UIKit

class PersonViewController: UITableViewController {
    
    var delegate: PeopleCoreDataDelegate!
    var person: Person?
    
    var hasPerson: Bool {
        return person != nil
    }
    
    var cellFirstName: PersonCell {
        return tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PersonCell
    }
    
    var cellLastName: PersonCell {
        return tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! PersonCell
    }
    
    var hasChanges: Bool {
        guard hasPerson else {
            return false
        }
        
        return person?.firstName != cellFirstName.textfield.text ||
            person?.lastName != cellLastName.textfield.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Person"
        tableView.register(PersonCell.self, forCellReuseIdentifier: "personCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if hasPerson {
            cellFirstName.textfield.text = person?.firstName
            cellLastName.textfield.text = person?.lastName
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (!(self.navigationController?.viewControllers.contains(self))!) {
            print(">>> PersonViewController viewWillDisappear BACK")
            if hasChanges {
                print(">>> PersonViewController viewWillDisappear hasChanges")
                person?.firstName = cellFirstName.textfield.text
                person?.lastName = cellLastName.textfield.text
                delegate?.update(person!)
            }
        }
        
        super.viewWillDisappear(animated)
    }
    
    @objc private func handleDone() {
        print(">>> PersonViewController handleDone()")
        if let firstName = cellFirstName.textfield.text,
            let lastName = cellLastName.textfield.text {
            delegate?.create(firstName, lastName)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // TableView DATA SOURCE DATA SOURCE DATA SOURCE DATA SOURCE DATA SOURCE DATA SOURCE
    //   DATA SOURCE DATA SOURCE DATA SOURCE DATA SOURCE DATA SOURCE DATA SOURCE DATA SOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PersonCell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonCell
        
        switch indexPath.row {
        case 0:
            cell.label.text = "First Name"
            cell.textfield.placeholder = "John"
            cell.textfield.becomeFirstResponder()
        default:
            cell.label.text = "Last Name"
            cell.textfield.placeholder = "Doe"
        }
        
        return cell
    }
}
