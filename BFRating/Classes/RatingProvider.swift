//
// ██████╗ ██╗████████╗███████╗ █████╗  ██████╗████████╗ ██████╗ ██████╗ ██╗   ██╗
// ██╔══██╗██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗╚██╗ ██╔╝
// ██████╔╝██║   ██║   █████╗  ███████║██║        ██║   ██║   ██║██████╔╝ ╚████╔╝
// ██╔══██╗██║   ██║   ██╔══╝  ██╔══██║██║        ██║   ██║   ██║██╔══██╗  ╚██╔╝
// ██████╔╝██║   ██║   ██║     ██║  ██║╚██████╗   ██║   ╚██████╔╝██║  ██║   ██║
// ╚═════╝ ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝
//
// Copyright (c) 2019 Bitfactory GmbH. All rights reserved.
// https://www.bitfactory.io
//
// Redistribution and use in source and binary forms, with or without
// modification, are not permitted.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//  RatingProvider.swift
//  BFRating
//

import UIKit
import StoreKit
import SwiftyUserDefaults
import Localize_Swift

public class RatingProvider {
    
    private let dayInSeconds: Int = 86400
    
    private var controller: UIViewController
    
    private var tintColor: UIColor
    
    public init(controller: UIViewController, tintColor: UIColor = .blue) {
        self.controller = controller
        self.tintColor = tintColor
    }
    
    public func showRatingDialog(afterDays days: Int = 14,
                                 afterViewCount viewCounts: Int = 5,
                                 onYesFeedback: (() -> Void)? = nil,
                                 onLaterFeedback: (() -> Void)? = nil,
                                 onNoFeedback: (() -> Void)? = nil) {
        
        if Defaults[.appStarts] == -1 {
            return
        }
        
        Defaults[.appStarts] += 1
        
        if Defaults[.appStarts] >= days
            && Defaults[.firstTimestamp] + Double(viewCounts * dayInSeconds) <= Date().timeIntervalSince1970 {
            Defaults[.appStarts] = -1
            
            showLikeAlert(onYesFeedback: onYesFeedback,
                          onLaterFeedback: onLaterFeedback,
                          onNoFeedback: onNoFeedback)
            
            return
        }
    }

    public func reset() {
        Defaults[.appStarts] = 0
        Defaults[.firstTimestamp] = Date().timeIntervalSince1970
    }
    
    public func showRatingDialogOnClick(onYesFeedback: (() -> Void)? = nil,
                                        onLaterFeedback: (() -> Void)? = nil,
                                        onNoFeedback: (() -> Void)? = nil) {
        showLikeAlert(onYesFeedback: onYesFeedback,
                      onLaterFeedback: onLaterFeedback,
                      onNoFeedback: onNoFeedback)
    }
    
    public func showRatingDialog(customValues values: [Int],
                                 onYesFeedback: (() -> Void)? = nil,
                                 onLaterFeedback: (() -> Void)? = nil,
                                 onNoFeedback: (() -> Void)? = nil) {
        let customValues = Defaults[.customValues]
        
        if compare(values1: customValues, values2: values) {
            showLikeAlert(onYesFeedback: onYesFeedback, onLaterFeedback: onLaterFeedback, onNoFeedback: onNoFeedback)
        }
    }
    
    fileprivate func compare(values1: [Int], values2: [Int]) -> Bool {
        if values1.count != values2.count {
            return false
        }
        
        for (index, element) in values1.enumerated() {
            if (element < values2[index]) {
                return false
            }
        }
        
        return true
    }
    
    public func setUserValues(_ values: [Int]) {
        Defaults[.customValues] = values
    }
    
    public func resetUserValues() {
        Defaults[.customValues] = []
    }
    
    private func showLikeAlert(onYesFeedback: (() -> Void)? = nil,
                               onLaterFeedback: (() -> Void)? = nil,
                               onNoFeedback: (() -> Void)? = nil) {
        guard var appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return
        }
        
        if let bundleName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            appName = bundleName
        }
        
        let alert = UIAlertController(title: nil,
                                      message: String(format: "ShowLikeAlert_Message".localized(), appName),
                                      preferredStyle: .alert)
        alert.view.tintColor = tintColor
        
        let noAction = UIAlertAction(title: "No".localized(), style: .cancel) { action in
            self.showFeedbackAlert(onYesFeedback: onYesFeedback, onLaterFeedback: onLaterFeedback, onNoFeedback: onNoFeedback)
        }
        
        alert.addAction(noAction)
        
        let yesAction = UIAlertAction(title: "Yes".localized(), style: .default) { action in
            self.reset()
            SKStoreReviewController.requestReview()
        }
        
        alert.addAction(yesAction)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    private func showFeedbackAlert(onYesFeedback: (() -> Void)? = nil,
                                   onLaterFeedback: (() -> Void)? = nil,
                                   onNoFeedback: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil,
                                      message: "ShowFeedbackAlert_Message".localized(),
                                      preferredStyle: .alert)
        alert.view.tintColor = tintColor
        
        let yesAction = UIAlertAction(title: "ShowFeedbackAlert_YesAction".localized(), style: .default) { action in
            if let positive = onYesFeedback {
                positive()
            }
        }
        
        alert.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "ShowFeedbackAlert_NoAction".localized(), style: .default) { action in
            Defaults[.appStarts] = -1
            
            if let negative = onNoFeedback {
                negative()
            }
        }
        
        alert.addAction(noAction)
        
        let laterAction = UIAlertAction(title: "ShowFeedbackAlert_LaterAction".localized(), style: .cancel) { action in
            self.reset()
            
            if let later = onLaterFeedback {
                later()
            }
        }
        
        alert.addAction(laterAction)
        
        controller.present(alert, animated: true, completion: nil)
    }
}
