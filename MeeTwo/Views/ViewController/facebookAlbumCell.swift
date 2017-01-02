//
//  facebookAlbumCell.swift
//  MeeTwo
//
//  Created by Apple 1 on 02/01/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

import UIKit

class facebookAlbumCell: UITableViewCell {

    @IBOutlet var imgProfileObj: UIImageView!
    
    @IBOutlet var lblAlbumTitle: UILabel!
    
    @IBOutlet var lblAlbumDesc: UILabel!
    
    
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
