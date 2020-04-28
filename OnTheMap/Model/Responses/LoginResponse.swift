//
//  File.swift
//  OnTheMap
//
//  Created by Natasha Stopa on 4/26/20.
//  Copyright © 2020 Stopa Inc. All rights reserved.
//

import Foundation

    
struct LoginResponse : Codable {
    let account : Account
    let session : Session
}

extension LoginResponse: LocalizedError {
var errorDescription: String? {
    return "Error"
    }
}
