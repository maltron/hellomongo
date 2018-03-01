//
//  ViewController.swift
//  hellomongo
//
//  Created by Mauricio Leal on 2/27/18.
//  Copyright © 2018 Mauricio Leal. All rights reserved.
//

import UIKit
import CoreData

protocol PeopleCoreDataDelegate {
    func create(_ firstName: String, _ lastName: String)
    func update(_ person: Person)
}

class PersonResult: Codable {
    var firstName: String
    var lastName: String
}

class PeopleViewController: UITableViewController, NSFetchedResultsControllerDelegate, PeopleCoreDataDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = NSPersistentContainer(name: "People")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as NSError? {
                fatalError("### UNABLE TO LOAD CORE DATA: \(error)")
            }
        })
        
        return container
    }()
    
    var fetchedResultsController: NSFetchedResultsController<Person>!
    
    // TEST TEST TEST TEST TEST TEST
    @objc func handleTest() {
        
        let url: URL = URL(string: "http://hellomongo-app-hellomongo.cloudapps.maltron.solutionarchitectsredhat.com.br/api/v1/person")!
        
        if let json: Data = performRequest(url: url) {
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode([PersonResult].self, from: json)
                for personResult in result {
                    print(">>> \(personResult.firstName) \(personResult.lastName)")
                }
            } catch let decodeErr {
                print("### handleTest() UNABLE TO DECODE:", decodeErr)
            }
        }
        
        
    }
    
    private func performRequest(url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch let performErr {
            print("### performRequest() UNABLE TO FETCH:", performErr)
        }
        
        return nil
    }
    
    private func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TESTING SUBMIT
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "TEST", style: .plain, target: self, action: #selector(handleTest))
        
        // Setup Navigation
        navigationItem.title = "People"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(handleAdd))
        
        // Setup TableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "peoplecell")
        
        // Setup Core Data
        loadCoreData()
    }
    
    @objc func handleAdd() {
        let personViewController: PersonViewController = PersonViewController()
        personViewController.delegate = self
        navigationController?.pushViewController(personViewController, animated: true)
    }
    
    // Delegate PEOPLE COREDATA PEOPLE COREDATA PEOPLE COREDATA PEOPLE COREDATA PEOPLE COREDATA
    //  PEOPLE COREDATA PEOPLE COREDATA PEOPLE COREDATA PEOPLE COREDATA PEOPLE COREDATA PEOPLE COREDATA
    func create(_ firstName: String, _ lastName: String) {
        let context: NSManagedObjectContext = persistentContainer.viewContext
        let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        let newPerson: Person = Person(entity: entity, insertInto: context)
        newPerson.firstName = firstName
        newPerson.lastName = lastName
        
        do {
            try context.save()
        } catch let createErr {
            print("### create(_:_) UNABLE TO SAVE DATA:", createErr)
        }
    }
    
    func update(_ person: Person) {
        let context: NSManagedObjectContext = persistentContainer.viewContext
        
        do {
            try context.save()
        } catch let updateErr {
            print("### update(_:_) UNABEL TO SAVE DATA:", updateErr)
        }
    }

}

