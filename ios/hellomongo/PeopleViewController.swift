//
//  PeopleViewController
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
    func delete(_ person: Person)
}

class PeopleViewController: UITableViewController, NSFetchedResultsControllerDelegate, PeopleCoreDataDelegate {
    
    let serverURL: URL? = URL(string: "http://hellomongo-app-hellomongo.cloudapps.maltron.solutionarchitectsredhat.com.br")
    
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
    var dataTask: URLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print(">>> create() \(firstName) \(lastName)")
        // The data will be persisted only when there is confirmed response from server
        dataTask?.cancel()
        
        var request: URLRequest = URLRequest(url: URL(string: "/api/v1/person", relativeTo: serverURL!)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = toJSON(id: nil, firstName: firstName, lastName: lastName)

        dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    // Network Failure
                    self.showNetworkFailure()
                }
                
            } else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 201,
                let data = data, let result = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.networkingBusy(status: false)
                    // Success: Code 201
                    self.coredataCreate(result, firstName, lastName)
                }
            }
        })
        networkingBusy(status: true)
        dataTask?.resume()
    }
    
    private func coredataCreate(_ id: String, _ firstName: String, _ lastName: String) {
        let context: NSManagedObjectContext = persistentContainer.viewContext
        let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        let newPerson: Person = Person(entity: entity, insertInto: context)
        newPerson.id = id
        newPerson.firstName = firstName
        newPerson.lastName = lastName
        
        do {
            try context.save()
        } catch let createErr {
            print("### create(_:_) UNABLE TO SAVE DATA:", createErr)
        }
    }
    
    func update(_ person: Person) {
        guard let id = person.id, let url = URL(string: "/api/v1/person/\(id)", relativeTo: serverURL) else {
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = toJSON(person: person)
        
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let _ = error {
                // Network Failure
                DispatchQueue.main.async {
                    self.showNetworkFailure()
                }

            } else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 202 { // 202: Accepted
                DispatchQueue.main.async {
                    self.networkingBusy(status: false)
                    self.coredataUpdate(person)
                }
            }
        })
        dataTask?.resume()
    }
    
    private func coredataUpdate(_ person: Person) {
        let context: NSManagedObjectContext = persistentContainer.viewContext
        
        do {
            try context.save()
        } catch let updateErr {
            print("### update(_:_) UNABEL TO SAVE DATA:", updateErr)
        }
    }
    
    func delete(_ person: Person) {
        guard let id = person.id, let url = URL(string: "/api/v1/person/\(id)", relativeTo: serverURL)  else {
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let _ = error {
                // Network Failure
                DispatchQueue.main.async {
                    self.showNetworkFailure()
                }
            } else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 202 { // 202: Accepted
                DispatchQueue.main.async {
                    self.networkingBusy(status: false)
                }
            }
        })
        dataTask?.resume()
    }
}

