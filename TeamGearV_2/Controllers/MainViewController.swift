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
    
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    
    @IBOutlet weak var addButtonOutlet: UIBarButtonItem!
    
    
    
    var sortType:SortType = .date
    
    var managedObjectContext:NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistantContainer.viewContext
    
    var fetchedResultsController:NSFetchedResultsController<BorrowedItem>? {
        didSet {
            fetchedResultsController?.delegate = self
            executeSearch()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BorrowedItem")
//                    let request = NSBatchDeleteRequest(fetchRequest: fetch)
//                do {
//                    let result = try managedObjectContext!.execute(request)
//                    print("Deletion completed")
//                } catch {
//                    print("Error:\(error.localizedDescription)")
//                }
        
        
        navigationController?.navigationBar.barTintColor = UIColor.darkBlue_1
        addButtonOutlet.tintColor = UIColor.white
        
        tableView.backgroundColor = UIColor.darkBlue_3
        
        configureSegmentedIndex()
        tableView.separatorColor = UIColor.pinkish
        setupTableViewDelegates()
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    @IBAction func addItemButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "addSegue", sender: self)
    }
    
    @IBAction func sortingActionChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sortType = .date
        case 1:
            sortType = .person
        default:
            print("Do nothing")
        }
        loadData()
    }
    
    
    

}





// MARK:- UITablelViewDelegate and Datasource functionality
extension MainViewController:UITableViewDelegate, UITableViewDataSource {
    
    func setupTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sortType == .date {
            return nil
        } else {
            if let sectionInfo = fetchedResultsController?.sections![section] {
                return sectionInfo.name
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       guard let items = fetchedResultsController?.sections?[section] else {
            return 0
       }
       return items.numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = fetchedResultsController?.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        if let item = item {
            
            configureCell(cell: cell, item: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "editSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

// MARK:- PrepareForSegue functionality
extension MainViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addSegue") {
            let controller = segue.destination as? DetailViewController
            controller?.itemState = .add
        } else if (segue.identifier == "editSegue") {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as? DetailViewController
                controller?.itemState = .edit
//                controller?.loadView()
                controller?.detailItem = fetchedResultsController?.object(at: indexPath)
            }
        }
    }
}

// MARK:- FetchedResultsControllerDelegate functionality
extension MainViewController:NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let set = IndexSet(integer: sectionIndex)
        
        switch (type) {
        case .insert:
            tableView.insertSections(set, with: .fade)
        case .delete:
            tableView.deleteSections(set, with: .automatic)
        default:
            // irrelevant in our case
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
        switch(type) {
            
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            configureCell(cell: tableView!.cellForRow(at: indexPath!)!, item: (anObject as? BorrowedItem)!)
   
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let context = self.fetchedResultsController?.managedObjectContext
            context?.delete((self.fetchedResultsController?.object(at: indexPath))!)
            do {
                try context?.save()
            } catch {
                print("error:\(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
        }
    }
    
    func loadData() {
        let request:NSFetchRequest = BorrowedItem.fetchRequest()
        
        let sortDescriptors:[NSSortDescriptor]?
        let sectionKeyPathName:String?
        switch sortType {
        case .date:
            sortDescriptors = [NSSortDescriptor(key: "endDate", ascending:  true)]
            sectionKeyPathName = nil
        case .person:
            sortDescriptors = [NSSortDescriptor(key: "person.name", ascending: false)]
            sectionKeyPathName = "person.name"
        default:
            print("do nothing")
        }
        
        request.sortDescriptors = sortDescriptors
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext!, sectionNameKeyPath: sectionKeyPathName, cacheName: nil)
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("error:\(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}

// MARK:- Clean up the UI
extension MainViewController {
    
    func configureSegmentedIndex() {
        segmentedOutlet.backgroundColor = UIColor.darkBlue
        segmentedOutlet.selectedSegmentTintColor = UIColor.darkBlue_3
        segmentedOutlet.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.pinkish], for: .normal)
        segmentedOutlet.layer.borderWidth = 2
        segmentedOutlet.layer.masksToBounds = true
        segmentedOutlet.layer.borderColor = UIColor.pinkish.cgColor
    }
    
    func configureCell(cell:UITableViewCell, item:BorrowedItem) {
        cell.textLabel?.text = item.title
        if let startDate = item.startDate, let endDate = item.endDate {
            cell.detailTextLabel?.text = "start date:\(Convenience.formatTheDate(date: startDate as NSDate)) end date:\(Convenience.formatTheDate(date: endDate as NSDate))"
            
                cell.imageView?.image = returnAppropriateImage(borrowedItem: item)
                cell.imageView?.layer.borderWidth = 1
                cell.imageView?.layer.borderColor = UIColor.pinkish.cgColor
                cell.imageView?.layer.masksToBounds = true
                cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
                
            

            switch setAlertForItemDueForReturn(borrowedItem: item) {
            case true:
                print("Contact the person you loaned to!",Convenience.formatForComparison(date: endDate), Convenience.formatForComparison(date: Date()))
                cell.backgroundColor = UIColor.pinkish
                cell.imageView?.layer.borderColor = UIColor.white.cgColor
            case false:
                print("It's not time yet.")
                cell.backgroundColor = UIColor.clear
                cell.imageView?.layer.borderColor = UIColor.pinkish.cgColor
            }

            
        }
    }
    
    
    func setAlertForItemDueForReturn(borrowedItem:BorrowedItem) -> Bool {
        if let endDate = borrowedItem.endDate, let endDateString = Convenience.formatForComparison(date: endDate) as? String, let nowDateString = Convenience.formatForComparison(date: Date()) as? String {
            
            if endDateString <= nowDateString {
                return true
            }
            return false
        }
       return false
    }
    
    
    func returnAppropriateImage(borrowedItem:BorrowedItem) -> UIImage? {
        switch sortType {
        case .date:
            if let data = borrowedItem.image {
                return UIImage(data: data)
            }
            return nil
        case .person:
            if let data = borrowedItem.person?.image {
                return UIImage(data: data)
            }
            return nil
        default:
            print("Do nothing.")
        }
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
//let borrowedItemRequest:NSFetchRequest<BorrowedItem> = BorrowedItem.fetchRequest()
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
//            print("item:\(item.title)", "number of items:\(item.numberOfItems)", "startDate:\(item.startDate)", "endDate:\(item.endDate)", "person:\(item.person?.name)")
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
