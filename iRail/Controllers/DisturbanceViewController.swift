//
//  DisturbanceViewController.swift
//  iRail
//
//  Created by Jan Baetens on 15/01/2019.
//  Copyright © 2019 Jan Baetens. All rights reserved.
//
import UIKit
import Alamofire

class DisturbanceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var disturbanceTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var disturbances: DisturbanceWrapper? = nil
    var touchedDisturbance:Disturbance? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disturbanceTableView.isHidden = true
        self.disturbanceTableView.dataSource = self
        self.disturbanceTableView.delegate = self
        getDisturbances()
    }
    
    func getDisturbances() {
        let request = Alamofire.request("https://api.irail.be/disturbances/?format=json&lang=en")
        request.validate()
        request.response { response in
            if response.error == nil {
                if let json = response.data {
                    let decoder = JSONDecoder()
                    self.disturbances = try! decoder.decode(DisturbanceWrapper.self, from: json)
                    self.disturbanceTableView.reloadData()
                }
                self.errorLabel.isHidden = true
                self.disturbanceTableView.isHidden = false
            }
            else if let err = response.error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
                self.disturbanceTableView.isHidden = true
                self.errorLabel.text = "Not Connected"
                self.errorLabel.isHidden = false
            }
            else if let err = response.error as? URLError, (err.code  == URLError.Code.timedOut || err.code == URLError.Code.cannotConnectToHost){
                self.disturbanceTableView.isHidden = true
                self.errorLabel.text = "Timed Out"
                self.errorLabel.isHidden = false
            }
            else {
                self.disturbanceTableView.isHidden = true
                if let json = response.data {
                    let decoder = JSONDecoder()
                    let error = try! decoder.decode(ErrorModel.self, from: json)
                    self.errorLabel.text = error.message
                    self.errorLabel.isHidden = false
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disturbances?.disturbance.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disturbanceTableViewCell", for: indexPath) as! DisturbanceTableViewCell
        if (disturbances != nil) {
            let title = disturbances?.disturbance[indexPath.item].title
            cell.titleLabel?.text = title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.touchedDisturbance = disturbances?.disturbance[indexPath.item]
        self.performSegue(withIdentifier: "disturbanceDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of DisturbanceDetailViewController
        let destinationVC = segue.destination as! DisturbanceDetailViewController
        destinationVC.disturbance = self.touchedDisturbance
    }
}
