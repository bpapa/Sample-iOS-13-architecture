//
//  Employee.swift
//  Employee Directory
//
//  Created by Brian Papa on 6/1/20.
//  Copyright © 2020 Brian Papa. All rights reserved.
//

import Foundation

/// JSON Container for the array of Employees
struct Employees: Codable {
    let employees: [Employee]
}

/// A JSON Object with employee information
struct Employee: Codable {
    /// One of the edge cases of the `convertFromSnakeCase` key decoding strategies is that URL is treated with sentence case when its typically capitalized, so custom coding keys must be provided to achieve the desired style
    private enum CodingKeys: String, CodingKey {
        case fullName, uuid, phoneNumber, emailAddress, biography, team, employeeType
        case photoURLSmall = "photoUrlSmall"
        case photoURLLarge = "photoUrlLarge"
    }
    
    let fullName: String
    let uuid: UUID
    let phoneNumber: String?
    let emailAddress: String
    let biography: String?
    let photoURLSmall: URL?
    let photoURLLarge: URL?
    let team: String
    let employeeType: EmployeeType
}

extension Employee: Equatable {}

enum EmployeeType: String, Codable {
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
    case contractor = "CONTRACTOR"
}
