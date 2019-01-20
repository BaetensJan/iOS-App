//
//  Departrue.swift
//  iRail
//
//  Created by Jan Baetens on 20/01/2019.
//  Copyright © 2019 Jan Baetens. All rights reserved.
//

public struct Departure: Codable {
    public let id: String
    public let delay: String
    public let station: String
    public let time: String
    public let platform: String
}

