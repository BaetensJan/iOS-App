//
//  ConnectionSearchController.swift
//  iRail
//
//  Created by Jan Baetens on 20/11/2018.
//  Copyright © 2018 Jan Baetens. All rights reserved.
//

import UIKit
import SearchTextField
import Alamofire


class ConnectionSearchController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // Connect your IBOutlet...
    @IBOutlet weak var toStationSearchField: SearchTextField!
    @IBOutlet weak var fromStationSearchField: SearchTextField!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var txtTimePicker: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var connectionTableView: UITableView!
    
    var connection: ConnectionWrapper? = nil
    let timePicker = UIDatePicker()
    let datePicker = UIDatePicker()
    
    var stationsNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionTableView.isHidden = true
        searchButton.layer.cornerRadius = 5
        searchButton.clipsToBounds = true
        
        txtDatePicker.delegate = self
        txtTimePicker.delegate = self
        self.connectionTableView.dataSource = self
        self.connectionTableView.delegate = self
        
        Alamofire.request("https://api.irail.be/stations/?format=json&lang=en").responseJSON { response in
            if let json = response.result.value {
                if let dictionary = json as? [String: Any] {
                    if let stations = dictionary["station"] as? [[String : Any]] {
                        stations.forEach{ station in
                            if let name = station["name"] as? String {
                                self.stationsNames.append(name)
                            }
                        }
                        self.stationsNames = self.stationsNames.sorted { $0 < $1 }
                        self.loadFilters()
                    }
                }
            }
        }
    }
    
    private func loadFilters() {
        self.toStationSearchField.filterStrings(self.stationsNames)
        self.fromStationSearchField.filterStrings(self.stationsNames)
    }
    
    
    
    func showDatePicker(){
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        
    }
    
    @objc func doneDatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        txtDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func showTimePicker(){
        timePicker.datePickerMode = .time
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtTimePicker.inputAccessoryView = toolbar
        txtTimePicker.inputView = timePicker
        
    }
    
    @objc func doneTimePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        txtTimePicker.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelTimePicker(){
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtDatePicker {
            showDatePicker()
        } else if textField == txtTimePicker {
            print("time")
            showTimePicker()
        }
    }
    
    @IBAction func searchButtonTouchUp(_ sender: Any) {
        Alamofire.request("https://api.irail.be/connections/?from=Gent-Sint-Pieters&to=Mechelen&date=301218&time=1230&timesel=departure&format=json&lang=en&fast=false&typeOfTransport=trains&alerts=false&results=6").responseJSON { response in
            if let json = response.data {
                let decoder = JSONDecoder()
                self.connection = try! decoder.decode(ConnectionWrapper.self, from: json)
                print(self.connection?.connection ?? "")
                self.connectionTableView.reloadData()
            }
            self.connectionTableView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connection?.connection.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectionTableViewCell", for: indexPath) as! ConnectionTableViewCell
        if (connection != nil) {
            let from = connection?.connection[indexPath.item].arrival.station
            let to = connection?.connection[indexPath.item].departure.station
            let fromTime = connection?.connection[indexPath.item].departure.time
            let toTime = connection?.connection[indexPath.item].arrival.time
            cell.toLabel?.text = to
            cell.fromLabel.text = from
            cell.departureTime?.text = convertFrom(fromTime!)
            cell.arrivalTime.text = convertFrom(toTime!)
        }
        return cell
    }
    
    func convertFrom(_ miliseconds: String) -> String {
        let date = Date(timeIntervalSince1970: Double(miliseconds)!)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}
