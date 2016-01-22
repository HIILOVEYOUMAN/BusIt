//
//  CardsAndMapViewController.swift
//  SidebarMenu
//
//  Created by Michael Young on 1/21/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class CardsAndMapViewController: UIViewController {
    
        @IBOutlet weak var menuButton:UIBarButtonItem!

        override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make hamburger icon clickable
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        

        // Do any additional setup after loading the view.
    }


}
