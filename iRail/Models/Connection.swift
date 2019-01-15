//
//  Connection.swift
//  iRail
//
//  Created by Jan Baetens on 20/11/2018.
//  Copyright © 2018 Jan Baetens. All rights reserved.
//

public struct Connection: Codable {
    public let id: String
    public let duration: String
    public let arrival: Landing
    public let departure: Landing
}
