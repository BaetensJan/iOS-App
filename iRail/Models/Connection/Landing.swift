//
//  Landing.swift
//  iRail
//
//  Created by Jan Baetens on 29/11/2018.
//  Copyright © 2018 Jan Baetens. All rights reserved.
//

public struct Landing: Codable{
    public let delay: String
    public let station: String
    public let time: String
    public let vehicle: String
    public let platform: String
    public let canceled: String
}
