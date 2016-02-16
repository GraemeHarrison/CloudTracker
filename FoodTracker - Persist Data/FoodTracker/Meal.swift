//
//  Meal.swift
//  FoodTracker
//
//  Created by Graeme Harrison on 2016-02-16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation
import CloudKit


struct Meal {
    let name: String
    let imageURL: NSURL
    let rating: Int
    
    init(name: String, rating: Int, imageURL: NSURL) {
        self.rating = rating
        self.name = name
        self.imageURL = imageURL
    }
    
    init(record: CKRecord) {
        if let name = record["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        let rating = record["rating"] as? Int
        self.rating = rating!
        
        let imageAsset = record["image"] as! CKAsset
        self.imageURL = imageAsset.fileURL
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "Meal")
        
        record["name"] = self.name
        record["rating"] = self.rating
        let imageAsset = CKAsset(fileURL: self.imageURL)
        record["image"] = imageAsset
        
        return record
    }
}