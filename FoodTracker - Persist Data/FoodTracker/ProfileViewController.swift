//
//  ProfileViewController.swift
//  FoodTracker
//
//  Created by Graeme Harrison on 2016-02-15.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import CloudKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userTypeLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
//    var imageURL : NSURL!
    
    var userID: CKRecordID!
    var profileRecord: CKRecord!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserId()
    }
    
    func fetchUserId() {
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (userID, error) -> Void in
            if error == nil {
                self.fetchRecords(userID!)
            }
        }
    }
    
    func fetchRecords(userID : CKRecordID) {
        let db = CKContainer.defaultContainer().publicCloudDatabase
        db.fetchRecordWithID(userID) { record, error in
            // if version
            if let r = record {
                self.profileRecord = r
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.usernameLabel.text = r["username"] as? String ?? ""
                    self.userTypeLabel.text = r["userType"] as? String ?? ""
                    
                    let imageURL = r["image"] as? NSURL
                    let imageData = NSData(contentsOfURL: imageURL!)
                    self.profileImageView.image = UIImage(data: imageData!)
                }
                
            } else {
                print("error getting user record")
            }
            
            // guard version
            guard let r = record else {
                print("error getting user record")
                return
            }
            
            self.profileRecord = r
            
            dispatch_async(dispatch_get_main_queue()) {
                self.usernameLabel.text = r["username"] as? String ?? ""
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
