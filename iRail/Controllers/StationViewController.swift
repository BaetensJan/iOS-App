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
        let request = Alamofire.request("https://api.irail.be/stations/?format=json&lang=en")
        request.validate()
        request.response { response in
            if response.error == nil {
                if let json = try! JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any] {
                    if let stations = json["station"] as? [[String : Any]] {
                        stations.forEach{ station in
                            if let name = station["name"] as? String {
                                self.stationsNames.append(name)
                            }
                        }
                    }
                }
            }
            else if let err = response.error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
                self.stationTableView.isHidden = true
                print("NotConnected")
            }
            else
            {
                self.stationTableView.isHidden = true
                if let json = response.data {
                    let decoder = JSONDecoder()
                    let error = try! decoder.decode(ErrorModel.self, from: json)
                    print(error.message)
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

