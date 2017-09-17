//
//  Contact.swift
//  BgLive
//
//  Created by Nabil K on 2017-09-16.
//  Copyright © 2017 Nabil. All rights reserved.
//

import UIKit
import Contacts

struct Contact: Equatable {
    
    let name: String
    let phoneNumber: String
    let picture: UIImage?
    
    init?(contact: CNContact){
        
        
        guard contact.phoneNumbers.count > 0 else { return nil }
        
        var image: UIImage? = nil
        if let imageData = contact.imageData {
            image = UIImage(data: imageData)
        }
        
        self.picture = image
        self.name = "\(contact.givenName) \(contact.familyName)"
        self.phoneNumber = contact.phoneNumbers[0].value.stringValue.cleanPhoneNumber()
   
    }
    
    
    init(name: String, phoneNumber: String, picture: UIImage?) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.picture = picture
    }
    
    
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber
    }
    
}
