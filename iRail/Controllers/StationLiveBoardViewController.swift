//
//  StationLiveBoardViewController.swift
//  iRail
//
//  Created by Jan Baetens on 15/01/2019.
//  Copyright © 2019 Jan Baetens. All rights reserved.
//
import UIKit
import Alamofire

class StationLiveBoardViewController: UIViewController {
    
    @IBOutlet weak var stationLabel: UILabel!
    
    var station: String = ""
    //https://api.irail.be/liveboard/?id=BE.NMBS.008892007&station=Gent-Sint-Pieters
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stationLabel.text = station
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
}
