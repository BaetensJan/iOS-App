//
//  StationViewController.swift
//  iRail
//
//  Created by Jan Baetens on 15/01/2019.
//  Copyright © 2019 Jan Baetens. All rights reserved.
//
import UIKit
import Alamofire

class StationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var stationTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var stationTextField: UITextField!
    
    var stationsNames: [String] = []
    var results:[String] = []
    var touchedStation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton.layer.cornerRadius = 5
        searchButton.clipsToBounds = true
        
        self.stationTableView.dataSource = self
        self.stationTableView.delegate = self
        stationTableView.isHidden = true
        loadStations()
    }
    
    func loadStations() {
        Alamofire.request("https://api.irail.be/stations/?format=json&lang=en").responseJSON { response in
            if let json = response.result.value {
                if let dictionary = json as? [String: Any] {
                    if let stations = dictionary["station"] as? [[String : Any]] {
                        stations.forEach{ station in
                            if let name = station["name"] as? String {
                                self.stationsNames.append(name)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func touchUp(_ sender: Any) {
        results = []
        for name in stationsNames
        {
            if name.lowercased().contains(stationTextField!.text!.lowercased()) {
                self.results.append(name)
            }
        }
        print(self.results)
        self.stationTableView.reloadData()
        stationTableView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationTableViewCell", for: indexPath) as! StationTableViewCell
            cell.stationLabel?.text = results[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.touchedStation = results[indexPath.item]
        self.performSegue(withIdentifier: "stationLiveBoardSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of StationLiveBoardViewController
        let destinationVC = segue.destination as! StationLiveBoardViewController
        destinationVC.station = self.touchedStation
    }
}

