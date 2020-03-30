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
    
    var itemState:ItemState?
    var itemCount:Int16? = 1
    var borrowedItemToEdit:BorrowedItem? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var numberOfItemsLblOutlet: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
