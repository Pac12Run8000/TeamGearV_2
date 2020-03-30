//
//  MainViewController.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 3/29/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var managedObjectContext:NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistantContainer.viewContext
        
        
        
        
         
        
        setupTableViewDelegates()
        

       
    }
    
    @IBAction func addItemButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "addSegue", sender: self)
    }
    
   

}


// MARK:- Prepare for segue functionality
extension MainViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addSegue") {
            let controller = segue.destination as? DetailViewController
            
            controller?.itemState = .add
            
        } else if (segue.identifier == "editSegue") {
            let controller = segue.destination as? DetailViewController
            
            controller?.itemState = .edit
        }
    }
    

}


// MARK:- UITablelViewDelegate and Datasource functionality
extension MainViewController:UITableViewDelegate, UITableViewDataSource {
    
    func setupTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        return cell
    }
    
    
    
}





//          Deletion from CoreData

//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BorrowedItem")
//            let request = NSBatchDeleteRequest(fetchRequest: fetch)
//        do {
//            let result = try managedObjectContext!.execute(request)
//            print("Deletion completed")
//        } catch {
//            print("Error:\(error.localizedDescription)")
//        }


        // Reading from CoreData
//        let borrowedItemRequest:NSFetchRequest<BorrowedItem> = BorrowedItem.fetchRequest()
//        borrowedItemRequest.returnsObjectsAsFaults = false
//
//        var borrowedItemsArray = [BorrowedItem]()
//
//        do {
//            borrowedItemsArray = try (managedObjectContext?.fetch(borrowedItemRequest))!
//        } catch {
//            print("error:\(error.localizedDescription)")
//        }
//
//        for item in borrowedItemsArray {
//            print("item:\(item.title)", "number of items:\(item.numberOfItems)")
//        }
    
        
        // Entering info to coredata
//        let borrowedItem = BorrowedItem(context: managedObjectContext!)
//        borrowedItem.title = "Level 1 USA Boxing Gloves"
//        borrowedItem.numberOfItems = 5
//        do {
//            try CoreDataStack.saveContext(context: managedObjectContext!)
//            print("Save was successful")
//        } catch {
//            print("error:\(error.localizedDescription)")
//        }
