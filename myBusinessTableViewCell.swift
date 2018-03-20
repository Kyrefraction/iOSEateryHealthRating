//
//  myBusinessTableViewCell.swift
//  Assignment
//
//  Created by Vincenzo Scialpi-Sullivan on 05/03/2018.
//  Copyright © 2018 Vincenzo Scialpi-Sullivan. All rights reserved.
//

import UIKit

class myBusinessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

