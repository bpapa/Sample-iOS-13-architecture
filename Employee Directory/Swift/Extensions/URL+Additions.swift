//
//  URL+Additions.swift
//  Employee Directory
//
//  Created by Brian Papa on 6/2/20.
//  Copyright © 2020 Brian Papa. All rights reserved.
//

import Foundation
import CryptoKit

extension URL {
    // MARK: - Class constants
    static let employeesURL = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json")!
    static let malformedURL = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json")!
    static let emptyURL = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json")!
    
    // MARK: - enums
    /// Enviornment variables that can be specified to configure this app at runtime
    private enum EnviornmentVariableKey: String {
        case malformed = "MalformedEmployees"
        case empty = "EmptyEmployees"
    }
    
    // MARK: - Generated properties
    /// Generates a URL to store resources with this URL on the filesystem. This `url` instance's path is hashed and the generated URL is located in Library/Caches. If there is a problem with the Caches directory, the returned URL is nil
    var cachedFileURL: URL? {
        let digest = Insecure.MD5.hash(data: absoluteString.data(using: .utf8)!)
        let filename = digest.map { String(format: "%02hhx", $0) }.joined()
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return nil }
        return cachesDirectory.appendingPathComponent(filename)
    }
    
    // MARK: - Class methods
    /// Creates a`URL` for the employees to access the employees endpoint based on configuration via enviornment variables
    /// - Returns: the `URL` to retrieve employees data
    static func makeEmployeesURLForEnviornment() -> URL {
        if isEnviornmentVariableSet(key: .malformed) {
            return malformedURL
        } else if isEnviornmentVariableSet(key: .empty) {
            return emptyURL
        }
        
        return employeesURL
    }
    
    // MARK: - private methods
    /// Determines if an enviornment variable has been set, and its value
    /// - Parameter key: the key for the environment variable
    /// - Returns: `true` if the key was set to true
    private static func isEnviornmentVariableSet(key: EnviornmentVariableKey) -> Bool {
        guard let enviornmentValue = ProcessInfo.processInfo.environment[key.rawValue], let enviornmentValueIsSet = Bool(enviornmentValue) else {
            return false
        }
        
        return enviornmentValueIsSet
    }
}
