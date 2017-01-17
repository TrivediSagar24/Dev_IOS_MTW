//
//  otherUserProfileCell.swift
//  MeeTwo
//
//  Created by Apple 1 on 16/01/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

import UIKit

class otherUserProfileCell: UITableViewCell
{

    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblAge: UILabel!
    
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblSchool: UILabel!
    @IBOutlet var lblCurrentWork: UILabel!
    @IBOutlet var viewDescriptionObj: UIView!
    
    @IBOutlet var viewSchoolDescObj: UIView!
    @IBOutlet var viewCurrentWorkObj: UIView!
    
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
