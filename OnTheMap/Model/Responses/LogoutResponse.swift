//
//  LogoutResponse.swift
//  OnTheMap
//
//  Created by Natasha Stopa on 4/27/20.
//  Copyright © 2020 Stopa Inc. All rights reserved.
//

import Foundation

struct LogoutResponse : Codable {
    let session : Session
}

extension LogoutResponse: LocalizedError {
var errorDescription: String? {
    return "Error"
    }
}
