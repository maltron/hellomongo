//
//  PeopleViewController+Networking.swift
//  hellomongo
//
//  Created by Mauricio Leal on 3/2/18.
//  Copyright © 2018 Mauricio Leal. All rights reserved.
//

import UIKit


class PersonJSON: Codable {
    var id: String?
    var firstName: String
    var lastName: String
    
    init(id: String? = nil, firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension PeopleViewController {
    
    func toJSON(person: Person) -> Data? {
        guard let firstName = person.firstName, let lastName = person.lastName else {
            return nil
        }
        
        return toJSON(id: person.id, firstName: firstName, lastName: lastName)
    }
    
    func toJSON(id: String?, firstName: String, lastName: String) -> Data? {
        do {
            return try JSONEncoder().encode(PersonJSON(id: id, firstName: firstName, lastName: lastName))
        } catch let jsonErr {
            print("### toJson() UNABLE TO ENCODE:", jsonErr)
        }
        
        return nil
    }
    
    func networkingBusy(status: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = status
    }
    
    func showNetworkFailure() {
        let alert = UIAlertController(title: "Failed", message: "Connection failed to Server", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
