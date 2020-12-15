//
//  EmployeeAPIController.swift
//  Employee Directory
//
//  Created by Brian Papa on 6/1/20.
//  Copyright © 2020 Brian Papa. All rights reserved.
//

import UIKit

enum EmployeeAPIError: Error {
    // Data was not returned by the server
    case noData
}

class EmployeeAPIController {
    
    /// Retrieves the employees from API
    /// - Parameter completion: a single argument closure with a `Result` containing an array of `Employee` instances on sucess
    func getEmployees(completion: @escaping (Result<[Employee], Error>) -> Void) {
        URLSession.shared.dataTask(with: URL.makeEmployeesURLForEnviornment()) { (data, response, error) in
            guard let data = data else {
                completion(.failure(EmployeeAPIError.noData))
                return
            }
            
            let jsonDecoder = EmployeeDirectoryJSONDecoder()
            do {
                let employees = try jsonDecoder.decode(Employees.self, from: data)
                completion(.success(employees.employees))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
