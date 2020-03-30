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
    lazy var managedObjectContext:NSManagedObjectContext = ((UIApplication.shared.delegate as? AppDelegate)?.persistantContainer.viewContext)!
    
    var variableTextField:UITextField!
    let datePicker = UIDatePicker()
    var itemState:ItemState?
    var itemCount:Int16? = 1
    var borrowedItemToEdit:BorrowedItem? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var numberOfItemsLblOutlet: UILabel!
    
    @IBOutlet weak var txtLoanOutlet: UITextField!
    
    @IBOutlet weak var txtReturnOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        txtLoanOutlet.delegate = self
        txtReturnOutlet.delegate = self
        
        if itemState == .add {
           let borrowedItem = BorrowedItem(context: managedObjectContext)
            
            
            
        } else if itemState == .edit {
           
        }
    }
    

    @IBAction func stepperAction(_ sender: UIStepper) {
        itemCount = Int16(sender.value)
        if let itemCount = itemCount {
            numberOfItemsLblOutlet.text = "number of items: \(Int(itemCount))"
        } 
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
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, h:mm a"
        let formattedDate = dateformatter.string(from: datePicker.date)
        variableTextField.text = "date borrowed: \(formattedDate)"
        self.view.endEditing(true)
        
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
