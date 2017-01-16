//
//  profileBottomCell.swift
//  MeeTwo
//
//  Created by Apple 1 on 16/01/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

import UIKit

class profileBottomCell: UITableViewCell {

    @IBOutlet var btnEditProfile: UIButton!
    @IBOutlet var btnSetting: UIButton!
    @IBOutlet var btnPersonality: UIButton!
    @IBOutlet var lblCurrentwork: UILabel!
    @IBOutlet var lblSchool: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblRightHere: UILabel!
    @IBOutlet var pageView: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var viewDescriptionObj: UIView!
    
    @IBOutlet var viewSchoolDescObj: UIView!
    
    @IBOutlet var viewCurrentWorkObj: UIView!
    
    @IBOutlet var heightConstraintOfDescriptionView: NSLayoutConstraint!
    
    @IBOutlet var HeightConstraintOfSchoolView: NSLayoutConstraint!
    
    @IBOutlet var HeightConstraintOfCurrentView: NSLayoutConstraint!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
