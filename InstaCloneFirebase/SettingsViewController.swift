//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by RIDVAN on 28.01.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("!error!")
        }
        
    }
    
   

}
