//
//  chatListCell.swift
//  MeeTwo
//
//  Created by Apple 1 on 23/01/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

import UIKit

class chatListCell: UITableViewCell
{

    
    @IBOutlet var userProfilePicObj: MIBadgeButton!
    
    @IBOutlet var imgViewUser: UIImageView!
    
    @IBOutlet var lblTime: UILabel!
    
    @IBOutlet var btnFavorite: UIButton!
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblLastChatObj: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        userProfilePicObj.layer.cornerRadius=userProfilePicObj.frame.size.width/2
        userProfilePicObj.clipsToBounds = true
        
        userProfilePicObj.badgeTextColor = UIColor.white
        userProfilePicObj.badgeBackgroundColor = UIColor.init(hexString: kblue_color)
        
        imgViewUser.layer.cornerRadius=imgViewUser.frame.size.width/2
        imgViewUser.layer.borderColor = UIColor.init(hexString: kblue_color).cgColor
        imgViewUser.layer.borderWidth = 2
        userProfilePicObj.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
