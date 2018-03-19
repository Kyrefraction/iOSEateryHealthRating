//
//  Company.swift
//  Assignment
//
//  Created by Vincenzo Scialpi-Sullivan on 05/03/2018.
//  Copyright © 2018 Vincenzo Scialpi-Sullivan. All rights reserved.
//

import Foundation

// Codeable so that we can automatically deserialize JSON to create objects of this class
class Company: Codable { // the attributes of this object match the incoming JSON from the server we expect
    let id: String
    let BusinessName: String
    let AddressLine1: String
    let AddressLine2: String
    let AddressLine3: String
    let PostCode: String
    let RatingValue: String
    let RatingDate: String
    let Latitude: String
    let Longitude: String
    let DistanceKM: String
}
