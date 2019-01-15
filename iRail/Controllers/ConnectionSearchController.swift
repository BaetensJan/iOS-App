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


class ConnectionSearchController: UIViewController, UITextFieldDelegate {
    
    // Connect your IBOutlet...
    @IBOutlet weak var toStationSearchField: SearchTextField!
    @IBOutlet weak var fromStationSearchField: SearchTextField!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var txtTimePicker: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var connectionTableView: UITableView!
    
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
                let connection = try! decoder.decode(ConnectionWrapper.self, from: json)
                print(connection.connection)
            }
            self.connectionTableView.isHidden = false
        }
    }
}
