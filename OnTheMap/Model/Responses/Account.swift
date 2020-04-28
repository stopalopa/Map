//
//  Account.swift
//  OnTheMap
//
//  Created by Natasha Stopa on 4/26/20.
//  Copyright © 2020 Stopa Inc. All rights reserved.
//

import Foundation


struct Account : Codable {
    let isRegistered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case isRegistered = "registered"
        case key
    }
}
