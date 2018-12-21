//
//  ViewController.swift
//  BFRating
//
//  Created by Matthias Nagel on 12/11/2018.
//  Copyright (c) 2018 Matthias Nagel. All rights reserved.
//

import UIKit
import BFRating
import MessageUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let ratingProvider = RatingProvider()
        ratingProvider.alertTintColor = UIColor.green //Default value UIColor.blue
        ratingProvider.showAfterDays = 10 // Default value 14
        ratingProvider.showAfterViewCount = 3 // Default value 5
        ratingProvider.show(self) {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                self.present(mail, animated: true)
            }
        }
    }
}
