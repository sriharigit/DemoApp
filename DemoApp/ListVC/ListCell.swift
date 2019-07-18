//
//  ListCell.swift
//  DemoApp
//
//  Created by Firoz on 14/07/19.
//  Copyright © 2019 Firoz. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        subView.layer.cornerRadius = 4.0
        subView.clipsToBounds = true
        
        profileImg.layer.masksToBounds = false
       profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
