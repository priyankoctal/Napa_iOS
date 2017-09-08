//
//  DiagnosisCell.swift
//  NAPA BILLING
//
//  Created by Admin on 05/05/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DiagnosisCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnSelect: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
