//
//  SignUpViewController.swift
//  FoodTracker
//
//  Created by Graeme Harrison on 2016-02-15.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import CloudKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var doneButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var image = UIImage()
    var imageURL : NSURL!
    let pickerViewValues = ["Food Critic", "Causual Foodie"]
    var userType : String!
    
    var userID: CKRecordID!
    var profileRecord: CKRecord!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareDelegates()
//        fetchRecords()
    }
    
    //MARK: CloudKit
    
//    func fetchRecords() {
//        let db = CKContainer.defaultContainer().publicCloudDatabase
//        db.fetchRecordWithID(self.userID) { record, error in
//            // if version
//            if let r = record {
//                self.profileRecord = r
//                
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.userNameTextField.text = r["username"] as? String ?? ""
//                }
//            } else {
//                print("error getting user record")
//            }
//            
//            // guard version
//            guard let r = record else {
//                print("error getting user record")
//                return
//            }
//            
//            self.profileRecord = r
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                self.userNameTextField.text = r["username"] as? String ?? ""
//            }
//        }
//    }
    
    func saveRecords() {
        //        self.profileRecord["username"] = self.userNameTextField.text
        //        self.profileRecord["userType"] = self.pickerViewValues
        //        self.profileRecord["image"] = self.imageURL
        
        let profile  = Profile(username: self.userNameTextField.text!, userType: self.pickerViewValues.description, imageURL: self.imageURL)
        
        let profileRecord = profile.toRecord()
        
        let container = CKContainer.defaultContainer()
        let db = container.publicCloudDatabase
        db.saveRecord(profileRecord) { record, error in
            guard record != nil else {
                print("error saving profile")
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                //could perform segue here or something, etc.
            }
        }
    }
    
    //MARK: Preparation
    
    func prepareDelegates() {
        userNameTextField.delegate = self
        imagePicker.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    //MARK: TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == userNameTextField {
            userNameTextField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userNameTextField.resignFirstResponder()
    }

    
    // MARK: UIImagePicker Controller
    @IBAction func showPhotoMenu(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let alertController = UIAlertController(title: "Use a Photo", message: "What would you like to do?", preferredStyle: .ActionSheet)
            
            let takePhoto = UIAlertAction(title: "Take a new photo", style: .Default) { (action) in self.takePhoto() }
            alertController.addAction(takePhoto)
            
            let choosePhoto = UIAlertAction(title: "Choose an existing photo", style: .Default) { (action) in self.choosePhotoFromLibrary() }
            alertController.addAction(choosePhoto)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in }
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            self.choosePhotoFromLibrary()
        }
    }
    
    func takePhoto() {
        imagePicker.sourceType = .Camera
        imagePicker.showsCameraControls = true
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Image
    
    func setProfilePicture(image: UIImage) {
        profileImageView.image = image
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let data = UIImagePNGRepresentation(image)
        let directory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let path = directory.path! + "/shoe.png"
        data!.writeToFile(path, atomically: true)
        self.imageURL = NSURL(fileURLWithPath: path)
        
        self.setProfilePicture(image)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UIPickerViewDelegate

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.userType = pickerViewValues[row]
        return pickerViewValues[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        //Save user type value to cloud
//        gradeTextField.text = gradePickerValues[row]
        self.view.endEditing(true)
    }
    
    //MARK: UIPickerViewDataSource
    
    // # of columns
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // # of rows
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    //MARK: Done Button
    
    @IBAction func done(sender: AnyObject) {
        saveRecords()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    // MARK: - Navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    }
    
}
