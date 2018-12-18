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
    
    private let controller: UIViewController!
    
    private let tintColor: UIColor!
    
    public init(_ controller: UIViewController,
                onFeedback: @escaping() -> (),
                showAfterViewCount: Int? = 5,
                alertTintColor: UIColor? = UIColor.blue) {
        
        self.controller = controller
        self.tintColor = alertTintColor
        
        if !Defaults.hasKey(.appStarts) {
            Defaults[.appStarts] = 0
        }
        
        if Defaults[.appStarts] == -1 {
            return
        }
        
        Defaults[.appStarts] += 1
        
        if Defaults[.appStarts] == showAfterViewCount {
            Defaults[.appStarts] = -1
            
            showLikeAlert {
                onFeedback()
            }
        }
    }
    
    public func reset() {
        Defaults[.appStarts] = 0
    }
    
    private func showLikeAlert(onFeedback: @escaping() -> ()) {
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
            self.showFeedbackAlert(onFeedback: {
                onFeedback()
            })
        }
        
        alert.addAction(noAction)
        
        let yesAction = UIAlertAction(title: "Yes".localized(), style: .default) { action in
            SKStoreReviewController.requestReview()
        }
        
        alert.addAction(yesAction)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    private func showFeedbackAlert(onFeedback: @escaping() -> ()) {
        let alert = UIAlertController(title: nil,
                                      message: "ShowFeedbackAlert_Message".localized(),
                                      preferredStyle: .alert)
        alert.view.tintColor = tintColor
        
        let yesAction = UIAlertAction(title: "ShowFeedbackAlert_YesAction".localized(), style: .default) { action in
            onFeedback()
        }
        
        alert.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "ShowFeedbackAlert_NoAction".localized(), style: .default) { action in
            Defaults[.appStarts] = -1
        }
        
        alert.addAction(noAction)
        
        let laterAction = UIAlertAction(title: "ShowFeedbackAlert_LaterAction".localized(), style: .cancel) { action in
            Defaults[.appStarts] = 0
        }
        
        alert.addAction(laterAction)
        
        controller.present(alert, animated: true, completion: nil)
    }
}
