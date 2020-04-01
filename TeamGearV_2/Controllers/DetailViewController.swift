//
//  DetailViewController.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 3/29/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    
    var imageState:ImageState?
    lazy var managedObjectContext:NSManagedObjectContext = ((UIApplication.shared.delegate as? AppDelegate)?.persistantContainer.viewContext)!
    
    
    var loanDate:Date?
    var returnDate:Date?
    var variableTextField:UITextField!
    let datePicker = UIDatePicker()
    var itemState:ItemState?
    var itemCount:Int16? = 1
    var borrowedItemToEdit:BorrowedItem? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var nameOfBorrowerLabelOutlet: UITextField!
    @IBOutlet weak var nameOfItemLabelOutlet: UITextField!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var numberOfItemsLblOutlet: UILabel!
    @IBOutlet weak var txtLoanOutlet: UITextField!
    @IBOutlet weak var txtReturnOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGesturecognizerForItemImageView()
        addGestureRecognizerForPersonImageView()

        txtLoanOutlet.delegate = self
        txtReturnOutlet.delegate = self
        
        
        
        if itemState == .add {
           let borrowedItem = BorrowedItem(context: managedObjectContext)
            
            
            
        } else if itemState == .edit {
           
        }
    }
    
    @objc func startitUp() {
        print("fuck it bro!!!")
    }
    

    @IBAction func stepperAction(_ sender: UIStepper) {
        itemCount = Int16(sender.value)
        if let itemCount = itemCount {
            numberOfItemsLblOutlet.text = "number of items: \(Int(itemCount))"
        } 
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        
        saveItemAndPersonData()
    }
    
    
    
}

// MARK:- DatePicker functionality
extension DetailViewController {
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        variableTextField.inputAccessoryView = toolbar
        variableTextField.inputView = datePicker
    }
    
    @objc func doneButtonPressed() {

        let dateformatter = returnDateFormatter()
        
        let formattedDate = dateformatter.string(from: datePicker.date)
        
        if (variableTextField == txtLoanOutlet) {
            loanDate = datePicker.date
            variableTextField.text = "date loaned: \(formattedDate)"
        } else if (variableTextField == txtReturnOutlet) {
            returnDate = datePicker.date
            variableTextField.text = "date of return: \(formattedDate)"
        }
        
        
        self.view.endEditing(true)
        
    }
    
    func returnDateFormatter() -> DateFormatter {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, h:mm a"
        return dateformatter
    }
    
}


// MARK:- UITextFieldDelegate functionality
extension DetailViewController:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtLoanOutlet || textField == txtReturnOutlet {
            variableTextField = textField
            createDatePicker()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

// MARK:- AlertController for field validation
extension DetailViewController {
    
    func presentLoginError(title:String, msg:String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func presentPersonActionSheet() {
        imageState = .person
        
        print("Working!!!!!")
        let imagePickerController = setImagePickerDelegate()

        let actionSheet = UIAlertController(title: "Image input", message: "Enter an image for the person who is borrowing the item.", preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                self.presentLoginError(title: "Camera no available" , msg: "The camera isn't available on this device.")
            }
        }
        let clearAction = UIAlertAction(title: "Clear", style: .default) { (action) in
            self.personImage.image = nil
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(clearAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func presentItemActionSheet() {
        imageState = .item
        let imagePickerController = setImagePickerDelegate()
        
        let actionSheet = UIAlertController(title: "Image input", message: "Select an image for the item that you are loaning out.", preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                self.presentLoginError(title: "Camera no available" , msg: "The camera isn't available on this device.")
            }
            
        }
        let clearAction = UIAlertAction(title: "Clear", style: .default) { (action) in
            self.itemImage.image = nil
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(clearAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK:- UILabel Animation functionality
extension DetailViewController {
    
    
    
    
    func fadeInFadeOut(label:UILabel) {
        DispatchQueue.main.async {
            if (label.alpha == 0.0) {
                UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveEaseOut, animations: {
                    label.alpha = 1.0
                }) { (success) in
                    if (success) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveEaseOut, animations: {
                                label.alpha = 0.0
                            }, completion: nil)
                        })
                    }
                }
            }
        }
    }
    
}


// MARK:--- Field Validation Functionality ---
extension DetailViewController {
    
    func saveItemAndPersonData() {
        
        guard validateItemImage() else {
            presentLoginError(title: "INPUT ERROR", msg: "Select an image for the item.")
            return
        }
        
        guard validateItemName() else {
            presentLoginError(title: "INPUT ERROR", msg: "Enter a valid item name.")
            return
        }
        
        guard validateTheDateItemIsBorrowed() else {
            presentLoginError(title: "INPUT ERROR", msg: "You have not properly selected a date the item is being borrowed. First, tap the date textfield and a date picker should appear. Select a date and press done.")
            return
        }
        
        guard validateDateItemIsReturned() else {
            presentLoginError(title: "INPUT ERROR", msg: "You have not properly selected a date the item is being borrowed. First, tap the date textfield and a date picker should appear. Select a date and press done.")
            return
        }
        
        guard validatePersonImageView() else {
            presentLoginError(title: "INPUT ERROR", msg: "Select an image for a person who is borrowing the item.")
            return
        }
        
        guard validatePersonName() else {
            presentLoginError(title: "INPUT ERROR", msg: "Enter a valid name for a user.")
            return
        }
        
        
        
        
        
        print("Saved!!!!")
    }
    
    func validateDateItemIsReturned() -> Bool {
        guard returnDate != nil else {
            txtReturnOutlet.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func validateTheDateItemIsBorrowed() -> Bool {
        guard loanDate != nil else {
            txtLoanOutlet.becomeFirstResponder()
            return false
        }
        return true
    }
    
    
    func validatePersonName() -> Bool {
        if nameOfBorrowerLabelOutlet.text == "" || nameOfBorrowerLabelOutlet.text!.isEmpty {
            nameOfBorrowerLabelOutlet.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func validatePersonImageView() -> Bool {
        if personImage.image == nil {
            personImage.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func validateItemName() -> Bool {
        if nameOfItemLabelOutlet.text == "" || nameOfItemLabelOutlet.text!.isEmpty {
            nameOfItemLabelOutlet.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func validateItemImage() -> Bool {
        if itemImage.image == nil {
            itemImage.becomeFirstResponder()
            return false
        }
        return true
    }
    
    
    
    
   
}

// MARK:- ImageView action and gesturerecognizer functionality
extension DetailViewController {
    
    func addGesturecognizerForItemImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentItemActionSheet))
        itemImage.isUserInteractionEnabled = true
        itemImage.addGestureRecognizer(tapGestureRecognizer)
        
       
    }
    
    func addGestureRecognizerForPersonImageView() {
        let tapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(presentPersonActionSheet))
        personImage.isUserInteractionEnabled = true
        personImage.addGestureRecognizer(tapGestureRecog)
        
         
    }
}


// MARK:- This is the imagepickerController functionality
extension DetailViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        switch imageState {
        case .item:
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let scaledImage = UIImage.scaleImage(image: editedImage, toWidth: 120, andHeight: 120) {
                self.itemImage.image = scaledImage
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let scaledImage = UIImage.scaleImage(image: originalImage, toWidth: 120, andHeight: 120) {
                self.itemImage.image = scaledImage
            }
        case .person:
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let scaledImage = UIImage.scaleImage(image: editedImage, toWidth: 120, andHeight: 120) {
                self.personImage.image = scaledImage
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let scaledImage = UIImage.scaleImage(image: originalImage, toWidth: 120, andHeight: 120) {
                self.personImage.image = scaledImage
            }
        default:
            print("Do nothing.")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func setImagePickerDelegate() -> UIImagePickerController {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }
}


