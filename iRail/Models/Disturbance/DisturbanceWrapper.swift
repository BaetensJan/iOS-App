//
//  DisturbanceWrapper.swift
//  iRail
//
//  Created by Jan Baetens on 15/01/2019.
//  Copyright © 2019 Jan Baetens. All rights reserved.
//

public struct DisturbanceWrapper: Codable {
    let version: String
    let timestamp: String
    let disturbance: [Disturbance]
}
