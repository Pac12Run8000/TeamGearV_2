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
    
    var detailItem:BorrowedItem?
    
    var imageState:ImageState?
    lazy var managedObjectContext:NSManagedObjectContext = ((UIApplication.shared.delegate as? AppDelegate)?.persistantContainer.viewContext)!
    
    
    
    var variableTextField:UITextField!
    let datePicker = UIDatePicker()
    
    var itemState:ItemState?
    
    var borrowedItemToEdit:BorrowedItem?
    
    @IBOutlet weak var isSavedMessageLabel: UILabel!
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var nameOfBorrowerLabelOutlet: UITextField!
    @IBOutlet weak var nameOfItemLabelOutlet: UITextField!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var datePickerStartDate: UIDatePicker!
    @IBOutlet weak var datePickerEndDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if itemState == .edit {
//            self.datePickerStartDate.date = (detailItem?.startDate)!
//            self.datePickerEndDate.date = (detailItem?.endDate)!
//        }
        
        
        
        
        
        addGesturecognizerForItemImageView()
        addGestureRecognizerForPersonImageView()


        
        
        messageLabelUI()
        
        populateFieldsForUpdate()
        
        configureTextFields()
        
        configureImageViews()
        
        view.backgroundColor = UIColor.darkBlue_3
        
        
        configureNavigationController()
        
        
    
    }
    
   
    
    @IBAction func btnSaveAction(_ sender: Any) {
        saveOrUpdateBorrowedItemAndPersonData()
        
        
    }
    
    
    
}



// MARK:- --- UI Layout ---
extension DetailViewController {
    
    func configureImageViews() {
        imageAttributes(imgView: itemImage)
        imageAttributes(imgView: personImage)
    }
    
    func configureTextFields() {
        textFieldattributes(textField: nameOfItemLabelOutlet)
        textFieldattributes(textField: nameOfBorrowerLabelOutlet)
    }
    
    func configureNavigationController() {
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func imageAttributes(imgView:UIImageView) {
        imgView.layer.cornerRadius = 4
        imgView.layer.masksToBounds = true
        imgView.layer.borderColor = UIColor.pinkish.cgColor
        imgView.layer.borderWidth = 1
        imgView.backgroundColor = UIColor.darkBlue_2
    }
    
    func textFieldattributes(textField:UITextField) {
        textField.layer.borderColor = UIColor.pinkish.cgColor
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
    }
    
}

// MARK:- DatePicker functionality
extension DetailViewController {
    
    func returnDateFormatter() -> DateFormatter {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, h:mm a"
        return dateformatter
    }
    
}


// MARK:- UITextFieldDelegate functionality
extension DetailViewController:UITextFieldDelegate {
    
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
    
    func saveOrUpdateBorrowedItemAndPersonData() {
        
        guard validateItemImage() else {
            presentLoginError(title: "INPUT ERROR", msg: "Select an image for the item.")
            return
        }
        
        guard validateItemName() else {
            presentLoginError(title: "INPUT ERROR", msg: "Enter a valid item name.")
            return
        }
        
        guard validateValidDateRange() else {
            presentLoginError(title: "INPUT ERROR", msg: "The date range is invalid. Make sure that your return date doesn't predate the loan date.")
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
        
        
        if itemState == .add {
            saveToCoreData()
        } else if itemState == .edit {
            updateToCoredata()
        }
        
        if let startDate = datePickerStartDate.date as? Date, let endDate = datePickerEndDate.date as? Date, let title = nameOfItemLabelOutlet.text {
            Convenience.setNotification(startDate: startDate, endDate: endDate, title: title)
        }
        
    }
    

    
    func validateValidDateRange() -> Bool {

        guard datePickerStartDate.date.compare(datePickerEndDate.date) == .orderedAscending else {
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


// MARK:- CoreData functionality
extension DetailViewController {
    
    func saveToCoreData() {
        let borrowedItem = BorrowedItem(context: managedObjectContext)
        if let data = itemImage.image?.jpegData(compressionQuality: 0.3) {
            borrowedItem.image = data
        }
        borrowedItem.title = nameOfItemLabelOutlet.text
        borrowedItem.startDate = self.datePickerStartDate.date
        borrowedItem.endDate = self.datePickerEndDate.date
        
       
        let person = Person(context: managedObjectContext)
        if let data = personImage.image?.jpegData(compressionQuality: 0.3) {
            person.image = data
        }
        person.name = nameOfBorrowerLabelOutlet.text
        person.addToBorrowedItems(borrowedItem)
        
        do {
         try CoreDataStack.saveContext(context: managedObjectContext)
            saveButtonOutlet.isEnabled = false
            self.isSavedMessageLabel.text = "Your information was saved. Click the \"Back\" button."
            fadeInFadeOut(label: isSavedMessageLabel)
            print("Save succeeded!")
        } catch {
            print("There was an error:\(error.localizedDescription)")
        }
        
        
    }
    
    func updateToCoredata() {
        detailItem?.title = nameOfItemLabelOutlet.text
        detailItem?.image = itemImage.image?.jpegData(compressionQuality: 0.3)
        detailItem?.startDate = datePickerStartDate.date
        detailItem?.endDate = datePickerEndDate.date
        
        var person = detailItem?.person
        person?.image = personImage.image?.jpegData(compressionQuality: 0.3)
        person?.name = nameOfBorrowerLabelOutlet.text
        
        
        do {
            try CoreDataStack.saveContext(context: managedObjectContext)
            self.isSavedMessageLabel.text = "The update was successful. Click the \"Back\" button."
            fadeInFadeOut(label: isSavedMessageLabel)
            print("BorrowedItem was updated.")
        } catch {
            print("error on save:\(error.localizedDescription)")
        }
    }
    
}

// MARK:- MessageLabel UI
extension DetailViewController {
    
    func messageLabelUI() {
        isSavedMessageLabel.layer.masksToBounds = true
        isSavedMessageLabel.layer.cornerRadius = 3
        isSavedMessageLabel.layer.borderWidth = 1
        isSavedMessageLabel.alpha = 0.0
    }
    
    
    func populateFieldsForUpdate() {
        if let detailItem = detailItem {
            
            if let data = detailItem.image {
                self.itemImage.image = UIImage(data: data)
            }
            
            self.datePickerStartDate.date = detailItem.startDate!
            self.datePickerEndDate.date = detailItem.endDate!
            self.nameOfItemLabelOutlet.text = detailItem.title

            
            let person = detailItem.person
            if let data = person?.image {
                self.personImage.image = UIImage(data: data)
            }
            self.nameOfBorrowerLabelOutlet.text = person?.name
        }
    }
}


