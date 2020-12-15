//
//  EmployeeDirectoryCodable.swift
//  Employee Directory
//
//  Created by Brian Papa on 6/1/20.
//  Copyright © 2020 Brian Papa. All rights reserved.
//

import UIKit

/// Subclass of`JSONEncoder` to ensure the same configuration is used across all client parsing code and tests
class EmployeeDirectoryJSONEncoder: JSONEncoder {
    override init() {
        super.init()
        keyEncodingStrategy = .convertToSnakeCase
    }
}

/// Subclass of`JSONDecoder` to ensure the same configuration is used across all client parsing code and tests
class EmployeeDirectoryJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
