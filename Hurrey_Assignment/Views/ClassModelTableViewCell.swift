//
//  ClassModelTableViewCell.swift
//  Hurrey_Assignment
//
//  Created by Nuthan Raju Pesala on 14/07/20.
//  Copyright © 2020 Nuthan Raju Pesala. All rights reserved.
//

import UIKit

class ClassModelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var mobileBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    
    var email = String()
    var phNumber = String()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
