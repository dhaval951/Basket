//
//  FontSizeScaleLabel.swift
//  MasterProject
//
//  Created by Sanjay Shah on 04/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class FontSizeScaleLabel: UILabel {
    
    override func draw(_ rect: CGRect) {
        
        if let usedFont:UIFont = self.font {
            
            if  self.tag != 100 {
                
                let scale = screenWidth / 320.0
                self.tag = 100
                self.font = UIFont(name: usedFont.fontName, size: CGFloat(usedFont.pointSize) * scale)!
            }
        }
        super.draw(rect)
    }    
}
