//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Natasha Stopa on 4/26/20.
//  Copyright © 2020 Stopa Inc. All rights reserved.
//

import Foundation

struct StudentLocation : Codable {
    let firstName: String
    let lastName: String
    let longitude: Float
    let latitude: Float
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}
