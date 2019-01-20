//
//  LiveboardWrapper.swift
//  iRail
//
//  Created by Jan Baetens on 20/01/2019.
//  Copyright © 2019 Jan Baetens. All rights reserved.
//

public struct LiveboardWrapper: Codable {
    let version: String
    let timestamp: String
    let station: String
    let departures: DeparturesWrapper
}

