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
    @IBOutlet weak var errorLabel: UILabel!
    
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
                        self.loadFilters()
                        self.errorLabel.isHidden = true
                    }
                }
            }
            else if let err = response.error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
                self.connectionTableView.isHidden = true
                self.errorLabel.text = "Not Connected"
                self.errorLabel.isHidden = false
            }

            else if let err = response.error as? URLError, (err.code  == URLError.Code.timedOut || err.code == URLError.Code.cannotConnectToHost){
                self.connectionTableView.isHidden = true
                self.errorLabel.text = "Timed Out"
                self.errorLabel.isHidden = false
            }
            else
            {
                self.connectionTableView.isHidden = true
                if let json = response.data {
                    let decoder = JSONDecoder()
                    let error = try! decoder.decode(ErrorModel.self, from: json)
                    self.errorLabel.text = error.message
                    self.errorLabel.isHidden = false
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
        
        let request = Alamofire.request("https://api.irail.be/connections/?from=\(fromStationSearchField.text ?? "")&to=\(toStationSearchField.text ?? "")&date=\(txtDatePicker!.text!.replacingOccurrences(of: "/", with: ""))&time=\(txtTimePicker!.text!.replacingOccurrences(of: ":", with: ""))&timesel=departure&format=json&lang=en&fast=false&typeOfTransport=trains&alerts=false&results=6")
        request.validate()
        request.response { response in
            if response.error == nil {
                if let json = response.data {
                    let decoder = JSONDecoder()
                    self.connection = try! decoder.decode(ConnectionWrapper.self, from: json)
                    print(self.connection?.connection ?? "")
                    self.connectionTableView.reloadData()
                }
                self.errorLabel.isHidden = true
                self.connectionTableView.isHidden = false
            }
            else if let err = response.error as? URLError, (err.code  == URLError.Code.timedOut || err.code == URLError.Code.cannotConnectToHost){
                self.connectionTableView.isHidden = true
                self.errorLabel.text = "Not Connected"
                self.errorLabel.isHidden = false
            }
            else if let err = response.error as? URLError, (err.code  == URLError.Code.timedOut || err.code == URLError.Code.cannotConnectToHost){
                self.connectionTableView.isHidden = true
                self.errorLabel.text = "Timed Out"
                self.errorLabel.isHidden = false
            }
            else {
                self.connectionTableView.isHidden = true
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
        return connection?.connection.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectionTableViewCell", for: indexPath) as! ConnectionTableViewCell
        if (connection != nil) {
            let from = connection?.connection[indexPath.item].departure.station
            let to = connection?.connection[indexPath.item].arrival.station
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
