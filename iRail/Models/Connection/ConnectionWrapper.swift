//
//  ConnectionWrapper.swift
//  iRail
//
//  Created by Jan Baetens on 20/11/2018.
//  Copyright © 2018 Jan Baetens. All rights reserved.
//

public struct ConnectionWrapper: Codable {
    let version: String
    let timestamp: String
    let connection: [Connection]
}
