//
//  Profile.swift
//  FoodTracker
//
//  Created by Graeme Harrison on 2016-02-15.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation
import CloudKit


struct Profile {
    let userType: String
    let username: String
    let imageURL: NSURL
    
    init(username: String, userType: String, imageURL: NSURL) {
        self.userType = userType
        self.username = username
        self.imageURL = imageURL
    }
    
    init(record: CKRecord) {
        if let username = record["username"] as? String {
            self.username = username
        } else {
            self.username = ""
        }
        
        let userType = record["userType"] as? String
        self.userType = userType!
        
        let imageAsset = record["image"] as! CKAsset
        self.imageURL = imageAsset.fileURL
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "Profile")
        
        record["username"] = self.username
        record["userType"] = self.userType
        let imageAsset = CKAsset(fileURL: self.imageURL)
        record["image"] = imageAsset
        
        return record
    }
}
