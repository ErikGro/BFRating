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
        
        let ratingProvider = RatingProvider(controller: self,
                                            tintColor: .green)
        
        // Customize alert directly in function
        ratingProvider.showRatingDialog(afterDays: 10,
                                        afterViewCount: 3,
                                        onYesFeedback: nil,
                                        onLaterFeedback: nil) {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                self.present(mail, animated: true)
            }
        }
        
        // Call rating dialog
        ratingProvider.showRatingDialogOnClick(onYesFeedback: {
            debugPrint("User clicks on Yes")
            // Do something here
        }, onLaterFeedback: {
            debugPrint("User clicks on Later")
            // Ask user to rate app again later
        }, onNoFeedback: {
            debugPrint("User clicks on No")
            // Open support chat or
            // Open MailComposer to write a feedback
            
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                self.present(mail, animated: true)
            }
        })
        
        // Call rating dialog after custom values
        let gamePlayed = 3
        let boughtItems = 1
        
        ratingProvider.showRatingDialog(customValues: [gamePlayed, boughtItems],
                                        onLaterFeedback: {
            // Reset user values
            ratingProvider.resetUserValues()
        }, onNoFeedback: {
            // Show support chat and reset user values
            ratingProvider.resetUserValues()
        })
        
        // F.e. user has played 3 games and bought 1 item
        // Set values with function:
        
        ratingProvider.setUserValues([3, 1])
        // Then ratingProvider.showRatingDialogAfterCustomValue will be called
    }
}
