//
//  QIMultiCell.swift
//  NAPA BILLING
//
//  Created by Admin on 02/05/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class QIMultiCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var btnUnSelect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
