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


extension EmergencyContactsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allContacts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let contact = self.allContacts[IndexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "e-cell", for: indexPath) as! EContactCollectionViewCell
        
        
        return cell
    }
    
}
