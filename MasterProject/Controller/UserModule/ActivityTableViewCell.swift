//
//  ActivityTableViewCell.swift
//  menuDemo
//
//  Created by Vivek Purohit on 06/09/17.
//  Copyright © 2017 zealous. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell
{

    //MARK: -IBOutlet
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var BtnAdd: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var ViewMain: UIView!
    @IBOutlet weak var AddView: UIView!
    @IBOutlet weak var addition: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var lblCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.AddView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
