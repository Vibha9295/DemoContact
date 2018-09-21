//
//  ViewController.swift
//  DemoConact
//
//  Created by vibha on 27/07/18.
//  Copyright © 2018 vibha. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts

class ViewController: UIViewController {
    var contactDetailArray = NSArray()
    
    @IBOutlet weak var tblContacts: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let cnContactStore = CNContactStore()
        cnContactStore.requestAccess(for: .contacts, completionHandler: { granted, error in
            if granted == true {
                let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
                let containerId = cnContactStore.defaultContainerIdentifier()
                let predicate: NSPredicate? = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
                let _: Error?
                if let aPredicate = predicate {
                    self.contactDetailArray = try! cnContactStore.unifiedContacts(matching: aPredicate, keysToFetch: keys as [CNKeyDescriptor]) as NSArray
                }
                DispatchQueue.main.async {
                    self.tblContacts.delegate = self
                    self.tblContacts.dataSource = self
                    self.tblContacts.reloadData()
                }
              
//                if error != nil {
//                    if let anError = error {
//                        print("error fetching contacts \(anError)")
//                    }
//                } else {
//                    self.tblContacts.reloadData()
//                }
            }
           
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetailArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! TableViewCell
        let CnContact = contactDetailArray[indexPath.row] as? CNContact
        for _: CNLabeledValue? in CnContact?.phoneNumbers ?? [CNLabeledValue?]() {
           // var phone = "\(label?.value ?? "")"
            //if phone.count > 0 {
             //   cell.lblName?.text = "Name - \(CnContact?.givenName ?? "") and  Phone  -\(phone)"
           // } else {
                cell.lblName?.text = CnContact?.givenName
            if CnContact!.imageData != nil{
                cell.imgUser.image = UIImage(data: CnContact!.imageData!)
            }
           // }
        }

        //cell.update(with: contacts[indexPath.row])
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! TableViewCell
//        
//       // print(cell.contactPhones(contacts[indexPath.row]))
//        //tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//    }
    
    
}


