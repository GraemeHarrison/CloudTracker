//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 5/27/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information.
//

import UIKit
import CloudKit

class MealTableViewController: UITableViewController {
    // MARK: Properties
    
    var applesMeals = [ApplesMeal]()
    var mealsArray = [Meal]()
    var userID: CKRecordID?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved meals, otherwise load sample data.
//        if let savedMeals = loadMeals() {
//            applesMeals += savedMeals
//        } else {
//            // Load the sample data.
//            loadSampleMeals()
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchUserID()
    }
    
//    func loadSampleMeals() {
//        let photo1 = UIImage(named: "meal1")!
//        let meal1 = ApplesMeal(name: "Caprese Salad", photo: photo1, rating: 4)!
//        
//        let photo2 = UIImage(named: "meal2")!
//        let meal2 = ApplesMeal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
//        
//        let photo3 = UIImage(named: "meal3")!
//        let meal3 = ApplesMeal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
//        
//        applesMeals += [meal1, meal2, meal3]
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = mealsArray[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.ratingControl.rating = meal.rating
        
        let imageURL = meal.imageURL
        let imageData = NSData(contentsOfURL: imageURL)
        cell.photoImageView.image = UIImage(data: imageData!)
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            mealsArray.removeAtIndex(indexPath.row)
//            saveMeals()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // show UI to let user know that fetching ID failed or is still in progress
        
        return userID != nil
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = mealsArray[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                mealsArray[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: mealsArray.count, inSection: 0)
                mealsArray.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            // Save the meals.
//            saveMeals()
        }
    }
    
    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowDetail" {
//            let mealDetailViewController = segue.destinationViewController as! MealViewController
//            
//            // Get the cell that generated this segue.
//            if let selectedMealCell = sender as? MealTableViewCell {
//                let indexPath = tableView.indexPathForCell(selectedMealCell)!
//                let selectedMeal = applesMeals[indexPath.row]
//                mealDetailViewController.applesMeal = selectedMeal
//            }
//        }
//        else if segue.identifier == "AddItem" {
//            print("Adding new meal.")
//        }
//    }
//    
//    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.applesMeal {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                // Update an existing meal.
//                applesMeals[selectedIndexPath.row] = meal
//                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
//            } else {
//                // Add a new meal.
//                let newIndexPath = NSIndexPath(forRow: applesMeals.count, inSection: 0)
//                applesMeals.append(meal)
//                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
//            }
//            // Save the meals.
//            saveMeals()
//        }
//    }
    
    // MARK: NSCoding
//    
//    func saveMeals() {
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(applesMeals, toFile: ApplesMeal.ArchiveURL.path!)
//        if !isSuccessfulSave {
//            print("Failed to save meals...")
//        }
//    }
//    
//    func loadMeals() -> [ApplesMeal]? {
//        return NSKeyedUnarchiver.unarchiveObjectWithFile(ApplesMeal.ArchiveURL.path!) as? [ApplesMeal]
//    }
    
    //MARK: CloudKit
    
    func fetchUserID() {
        let container = CKContainer.defaultContainer()
        container.fetchUserRecordIDWithCompletionHandler { recordID, error in
            if let e = error {
                print("error getting user record id: \(e.localizedDescription)")
                return
            }
            self.userID = recordID!
            self.fetchMeals()
        }
    }
    
    func fetchMeals() {
        let predicate = NSPredicate(value: true) // this means just evaluate to true, so fetch everything
//        let predicate = NSPredicate(format: "owner != %@", self.userID!) // get only shoes I posted
        let query = CKQuery(recordType: "Meal", predicate: predicate)
        
        let db = CKContainer.defaultContainer().publicCloudDatabase
        db.performQuery(query, inZoneWithID: nil) { records, error in
            if let e = error {
                print("error fething meals: \(e.localizedDescription)")
                return
            }
//            // regular loop
//            for record in records! {
//                self.mealsArray.append(Meal(record: record))
//            }
            // fancy map
            self.mealsArray = records!.map { record -> Meal in
                return Meal(record: record)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
}
