//
//  TermsViewController.swift
//  TeamGearV_2
//
//  Created by Michelle Grover on 4/11/20.
//  Copyright © 2020 Norbert Grover. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func acceptTermsAction(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.didAcceptPolicy)
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
