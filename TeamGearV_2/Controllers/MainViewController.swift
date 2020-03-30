//
//  MainViewController.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 3/29/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
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
