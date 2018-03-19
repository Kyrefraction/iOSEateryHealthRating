//
//  DEBUGCell.swift
//  Assignment
//
//  Created by Vincenzo Scialpi-Sullivan on 07/03/2018.
//  Copyright © 2018 Vincenzo Scialpi-Sullivan. All rights reserved.
//

import UIKit

class DEBUGCell: UITableViewCell {

    @IBOutlet weak var DEBUGLabel: UILabel!
    @IBOutlet weak var DEBUGImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
