//
//  EmergencyContactsViewController.swift
//  BgLive
//
//  Created by Nabil K on 2017-09-16.
//  Copyright © 2017 Nabil. All rights reserved.
//

import UIKit

class EmergencyContactsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    var allContacts = [Contact]()
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "add"{
            
            if let addContactsVc = segue.destination as? AddContactViewController {
                
                addContactsVc.delegate = self
                
            }
        }
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "add", sender: self)
    
        }
    

}


extension EmergencyContactsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allContacts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let contact = self.allContacts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "e-cell", for: indexPath) as! EContactCollectionViewCell
        
        cell.nameLabel.text = contact.name
        cell.numberLabel.text = contact.phoneNumber
        cell.contactImage.image = contact.picture
        
        return cell
    
    }
    
}


extension EmergencyContactsViewController : ContactUpdateDelegate {
    
    func updateContacts(contacts: [Contact]) {
        self.allContacts = contacts
        self.collectionView.reloadData()
    }
    
}
