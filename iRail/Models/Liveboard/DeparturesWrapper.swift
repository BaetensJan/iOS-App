//
//  DeparturesWrapper.swift
//  iRail
//
//  Created by Jan Baetens on 20/01/2019.
//  Copyright © 2019 Jan Baetens. All rights reserved.
//

public struct DeparturesWrapper: Codable {
    let number: String
    let departure: [Departure]
}
