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
        
        _ = RatingProvider(self, onFeedback: {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                self.present(mail, animated: true)
            }
        }, showAfterViewCount: 1,
           alertTintColor: UIColor.red)
    }
}
