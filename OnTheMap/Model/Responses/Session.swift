//
//  Session.swift
//  OnTheMap
//
//  Created by Natasha Stopa on 4/26/20.
//  Copyright © 2020 Stopa Inc. All rights reserved.
//

import Foundation

struct Session : Codable {
    let id : String
    let expirationTime: String

    enum CodingKeys: String, CodingKey {
        case id
        case expirationTime = "expiration"
    }
}
