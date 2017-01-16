//
//  NotificationCell.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 12/12/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet var imgUser: UIImageView!
    
    @IBOutlet var lblName: UILabel!
    
     @IBOutlet var lblWork: UILabel!
    
    @IBOutlet var btnAccept: UIButton!
    
     @IBOutlet var btnDecline: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        self.imgUser.layer.borderColor = self.btnAccept.backgroundColor?.cgColor
        self.imgUser.clipsToBounds = true
        self.imgUser.layer.borderWidth = 1
        
       btnAccept.layer.cornerRadius = 4
       btnDecline.layer.cornerRadius = 4
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
