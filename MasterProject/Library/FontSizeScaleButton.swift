//
//  FontSizeScaleButton.swift
//  MasterProject
//
//  Created by Sanjay Shah on 04/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class FontSizeScaleButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        
        if let usedFont : UIFont = self.titleLabel?.font {
            
            // define your reference size here
            
            if  self.tag != 100 {
                
                let scale = screenWidth / 320.0
                self.tag = 100
                self.titleLabel?.font = UIFont(name: usedFont.fontName, size: CGFloat(usedFont.pointSize) * scale)!
            }
        }
        super.draw(rect)
    }
}
