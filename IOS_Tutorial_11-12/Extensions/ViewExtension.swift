//
//  ViewExtension.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thái on 21/12/2022.
//

import Foundation
import UIKit

extension UIView {
    func circleView() {
        layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func dropShadow(color: CGColor, opacity: Float, cornerRadius: CGFloat, offSet: CGSize) {
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = cornerRadius
        self.layer.shadowOffset = offSet
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: self.bounds.maxY - self.layer.shadowRadius, width: self.bounds.width, height: self.layer.shadowRadius)).cgPath
    }
}