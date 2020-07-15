//
//  SchoolListTableViewCell.swift
//  Hurrey_Assignment
//
//  Created by Nuthan Raju Pesala on 14/07/20.
//  Copyright © 2020 Nuthan Raju Pesala. All rights reserved.
//

import UIKit

class SchoolListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var noOfStudentsLabel: UILabel!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        profilePic.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
