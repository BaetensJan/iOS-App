//
//  LiveboardTableViewCell.swift
//  iRail
//
//  Created by Jan Baetens on 20/01/2019.
//  Copyright © 2019 Jan Baetens. All rights reserved.
//

import UIKit

class LiveboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
