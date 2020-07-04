//
//  RoundButton.swift
//  SegmentedBundle
//
//  Created by 13216146 on 30/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    @IBInspectable var roundedCorner: CGFloat = 0 {
        didSet {
            refreshCorners(value: roundedCorner)
        }
    }
    
    func sharedInit() {
        refreshCorners(value: roundedCorner)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }

}
