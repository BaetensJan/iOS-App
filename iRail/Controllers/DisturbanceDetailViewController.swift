//
//  DisturbanceDetailViewController.swift
//  iRail
//
//  Created by Jan Baetens on 15/01/2019.
//  Copyright © 2019 Jan Baetens. All rights reserved.
//

import UIKit

class DisturbanceDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var disturbance: Disturbance? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = disturbance?.title
        self.descriptionLabel.text = disturbance?.description
        self.linkLabel.text = disturbance?.link
        let time = disturbance?.timestamp
        self.timeLabel.text = convertFrom(time!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if (navigationController?.topViewController != self) {
            navigationController?.navigationBar.isHidden = true
        }
        super.viewWillDisappear(animated)
    }
    
    func convertFrom(_ miliseconds: String) -> String {
        let date = Date(timeIntervalSince1970: Double(miliseconds)!)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

