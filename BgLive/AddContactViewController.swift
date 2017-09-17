//
//  SecondViewController.swift
//  BgLive
//
//  Created by Nabil K on 2017-09-16.
//  Copyright © 2017 Nabil. All rights reserved.
//

import UIKit
import Contacts

class AddContactViewController: UIViewController {

    var checked: [Contact] = []
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    
    var contactStore: CNContactStore!
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        return bar
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.close))
        return button
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UIPaddedTextField()
        textField.placeholder = "Search"
        textField.backgroundColor = UIColor.darkGray
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.textAlignment = .center
        return textField
    }()
    
    var completion: (([Contact]) -> Void)?
    
    init(users: [Contact], completion: @escaping ([Contact]) -> Void) {
        checked = users
        
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getContacts()
        
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    func setupViews() {
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: Constants.contactsTableViewCell)
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "Contacts"
        self.navigationItem.rightBarButtonItem = doneButton
        
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.tintColor = UIColor.green
        
        navigationBar.pushItem(self.navigationItem, animated: false)
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(tableView)
        self.view.addSubview(searchTextField)
        
        searchTextField.snp.makeConstraints{ (make) in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(35)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
    }
    
    func searchTextChanged() {
        var contactsFound: [Contact] = []
        
        if let text = searchTextField.text {
            contactsFound = contacts.filter({$0.name.lowercased().contains(text.lowercased())})
        }
        
        self.filteredContacts = contactsFound
        self.tableView.reloadData()
    }
    
    func getContacts() {
        contactStore = CNContactStore()
        requestForAccess { (success) in
            if success {
                let keys: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor]
                
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: self.contactStore.defaultContainerIdentifier())
                if let contacts = try? self.contactStore.unifiedContacts(matching: predicate, keysToFetch: keys) {
                    self.contacts = contacts.flatMap(Contact.init)
                    self.tableView.reloadData()
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    completionHandler(false)
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func close() {
        completion?(checked)
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getDataSource() -> [Contact]{
        if let text = self.searchTextField.text{
            if text.characters.count > 0{
                return filteredContacts
            }
        }
        
        return contacts
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getDataSource().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.contactsTableViewCell) as! ContactsTableViewCell
        let dataSource = getDataSource()
        cell.setup(name: dataSource[indexPath.row].name)
        
        if checked.contains(dataSource[indexPath.row]) {
            cell.setChecked(true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = tableView.cellForRow(at: indexPath) as! ContactsTableViewCell
        
        row.setSelected(false, animated: true)
        let dataSource = getDataSource()
        
        
        if let index = checked.index(of: dataSource[indexPath.row]) {
            checked.remove(at: index)
            row.setChecked(false)
        } else {
            checked.append(dataSource[indexPath.row])
            row.setChecked(true)
        }
    }
}

extension AddContactViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textLength = self.searchTextField.text?.characters.count ?? 0
        
        let textRange = NSRange(Range(uncheckedBounds: (0, textLength)))
        
        if NSEqualRanges(textRange, range) && string.characters.count == 0 {
            textField.textAlignment = .center
        } else {
            textField.textAlignment = .left
        }
        
        return true
    }
}

