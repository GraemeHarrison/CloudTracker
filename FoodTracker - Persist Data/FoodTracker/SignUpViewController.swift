//
//  SignUpViewController.swift
//  FoodTracker
//
//  Created by Graeme Harrison on 2016-02-15.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var doneButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var image = UIImage()
    
    let pickerViewValues = ["Food Critic", "Causual Foodie"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //save image to cloud
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.setProfilePicture(image)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
