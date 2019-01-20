//
//  StationLiveBoardViewController.swift
//  iRail
//
//  Created by Jan Baetens on 15/01/2019.
//  Copyright © 2019 Jan Baetens. All rights reserved.
//
import UIKit
import Alamofire

class StationLiveBoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var station: String = ""
    var liveboard: LiveboardWrapper? = nil
    
    @IBOutlet weak var liveboardTableView: UITableView!
    
    //https://api.irail.be/liveboard/?id=BE.NMBS.008892007&station=Gent-Sint-Pieters
    override func viewDidLoad() {
        super.viewDidLoad()

        liveboardTableView.isHidden = true
        self.liveboardTableView.dataSource = self
        self.liveboardTableView.delegate = self
        loadLiveboard()
    }
    
    func loadLiveboard() {
        let request = Alamofire.request("https://api.irail.be/liveboard/?id=BE.NMBS.008892007&station=\(station)&format=json")
        request.validate()
        request.response { response in
            if response.error == nil {
                if let json = response.data {
                    let decoder = JSONDecoder()
                    self.liveboard = try! decoder.decode(LiveboardWrapper.self, from: json)
                    self.liveboardTableView.reloadData()
                }
                self.liveboardTableView.isHidden = false
            }
            else if let err = response.error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
                self.liveboardTableView.isHidden = true
                print("NotConnected")
            } else {
                self.liveboardTableView.isHidden = true
                if let json = response.data {
                    let decoder = JSONDecoder()
                    let error = try! decoder.decode(ErrorModel.self, from: json)
                    print(error.message)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveboard?.departures.departure.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liveboardTableViewCell", for: indexPath) as! LiveboardTableViewCell
        if (liveboard != nil) {
            let direction = liveboard?.departures.departure[indexPath.item].station
            let platform = liveboard?.departures.departure[indexPath.item].platform
            let time = liveboard?.departures.departure[indexPath.item].time
            let delay = liveboard?.departures.departure[indexPath.item].delay
            cell.stationLabel?.text = direction
            cell.platformLabel?.text = "Platform: \(platform ?? "")"
            cell.timeLabel?.text = "\(convertFrom(time!)) + \((Int(delay ?? "0") ?? 0)/60)"
        }
        return cell
    }
    
    func convertFrom(_ miliseconds: String) -> String {
        let date = Date(timeIntervalSince1970: Double(miliseconds)!)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
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
