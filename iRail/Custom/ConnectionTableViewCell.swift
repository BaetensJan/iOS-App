//
//  ConnectionTableViewCell.swift
//  iRail
//
//  Created by Jan Baetens on 29/11/2018.
//  Copyright © 2018 Jan Baetens. All rights reserved.
//

import UIKit

class ConnectionTableViewCell: UITableViewCell {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
