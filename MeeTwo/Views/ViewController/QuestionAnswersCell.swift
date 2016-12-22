//
//  QuestionAnswersCell.swift
//  MeeTwo
//
//  Created by Apple 1 on 22/12/16.
//  Copyright © 2016 TheAppGuruz. All rights reserved.
//

import UIKit

class QuestionAnswersCell: UITableViewCell
{
    @IBOutlet var lblQuestionObj: UILabel!

    @IBOutlet var lblYesNoObj: UILabel!
    
    @IBOutlet var lblCountObj: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
