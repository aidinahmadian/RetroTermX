//
//  UIView+BlinkingExtension.swift
//  RetroTermX
//
//  Created by Aidin Ahmadian on 7/14/24.
//

import UIKit

extension UIView {
    func startBlink() {
        UIView.animate(
            withDuration: 0.8,
            delay: 0.0,
            options: [.repeat, .autoreverse],
            animations: { self.alpha = 0.2 },
            completion: nil
        )
    }
}
