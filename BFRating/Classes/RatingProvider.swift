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
    
    public var showAfterViewCount: Int = 5
    
    public var showAfterDays: Int = 14
    
    public var alertTintColor: UIColor = UIColor.blue
    
    public init(controller: UIViewController) {
        self.controller = controller
    }
    
    public func showRatingDialog(afterDays days: Int? = nil,
                                 afterViewCount viewCounts: Int? = nil,
                                 withColor tintColor: UIColor? = nil,
                                 onYesFeedback: (() -> Void)? = nil,
                                 onLaterFeedback: (() -> Void)? = nil,
                                 onNoFeedback: (() -> Void)? = nil) {
        
        if Defaults[.appStarts] == -1 {
            return
        }
        
        showAfterDays = days ?? 14
        showAfterViewCount = viewCounts ?? 5
        alertTintColor = tintColor ?? .blue
        
        Defaults[.appStarts] += 1
        
        if Defaults[.appStarts] >= showAfterViewCount
            && Defaults[.firstTimestamp] + Double(showAfterDays * dayInSeconds) <= Date().timeIntervalSince1970 {
            Defaults[.appStarts] = -1
            
            showLikeAlert(onYesFeedback: onYesFeedback, onLaterFeedback: onLaterFeedback, onNoFeedback: onNoFeedback)
            
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
        showLikeAlert(onYesFeedback: onYesFeedback, onLaterFeedback: onLaterFeedback, onNoFeedback: onNoFeedback)
    }
    
    public func showRatingDialog(afterCustomValue value1: Int? = nil,
                                 value2: Int? = nil,
                                 value3: Int? = nil,
                                 onYesFeedback: (() -> Void)? = nil,
                                 onLaterFeedback: (() -> Void)? = nil,
                                 onNoFeedback: (() -> Void)? = nil) {
        let userValue1 = Defaults[.userValue1]
        let userValue2 = Defaults[.userValue2]
        let userValue3 = Defaults[.userValue3]
        
        if userValue1 >= value1 ?? 0 && userValue2 >= value2 ?? 0 && userValue3 >= value3 ?? 0 {
            showLikeAlert(onYesFeedback: onYesFeedback, onLaterFeedback: onLaterFeedback, onNoFeedback: onNoFeedback)
        }
    }
    
    public func setUserValues(value1: Int? = nil, value2: Int? = nil, value3: Int? = nil) {
        if let value1 = value1 {
            Defaults[.userValue1] = value1
        }
        
        if let value2 = value2 {
            Defaults[.userValue2] = value2
        }
        
        if let value3 = value3 {
            Defaults[.userValue3] = value3
        }
    }
    
    public func resetUserValues() {
        Defaults[.userValue1] = 0
        Defaults[.userValue2] = 0
        Defaults[.userValue3] = 0
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
        alert.view.tintColor = alertTintColor
        
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
        alert.view.tintColor = alertTintColor
        
        let yesAction = UIAlertAction(title: "ShowFeedbackAlert_YesAction".localized(), style: .default) { action in
            SKStoreReviewController.requestReview()
        
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
