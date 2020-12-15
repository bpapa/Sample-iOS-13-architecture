//
//  EmployeeAPIControllerTests.swift
//  Employee DirectoryTests
//
//  Created by Brian Papa on 6/4/20.
//  Copyright © 2020 Brian Papa. All rights reserved.
//

import XCTest
@testable import Employee_Directory

class NoDataProtocol: URLProtocol {    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func stopLoading() {}
    
    override func startLoading() {
        client!.urlProtocol(self, didFailWithError: NSError(domain: "com.bpapa", code: 0, userInfo: nil))
    }
}

class InvalidJSONProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func stopLoading() {}
    
    override func startLoading() {
        let stringData = "Not JSON".data(using: .utf8)!
        client!.urlProtocol(self, didLoad: stringData)
        client!.urlProtocolDidFinishLoading(self)
    }
}

class ValidJSONProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func stopLoading() {}
    
    override func startLoading() {
        let encoder = EmployeeDirectoryJSONEncoder()
        let data = try! encoder.encode(Self.makeEmployees())
        client!.urlProtocol(self, didLoad: data)
        client!.urlProtocolDidFinishLoading(self)
    }
    
    static func makeEmployees() -> Employees {
        let employee = Employee(fullName: "Brian Papa", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!, phoneNumber: nil, emailAddress: "bpapa@icloud.com", biography: nil, photoURLSmall: nil, photoURLLarge: nil, team: "iOS Engineering", employeeType: .fullTime)
        return Employees(employees: [employee])
    }
}

class EmployeeAPIControllerTests: XCTestCase {

    // MARK: - properties
    var employeeAPIController: EmployeeAPIController!
    
    override func setUpWithError() throws {
        employeeAPIController = EmployeeAPIController()
    }

    func testGetEmployeesNoDataFailsWithError() {
        let failureExpectation = expectation(description: "No data Failure")
        
        URLProtocol.registerClass(NoDataProtocol.self)
        employeeAPIController.getEmployees { result in
            switch result {
            case .failure(let error):
                switch error {
                case EmployeeAPIError.noData:
                    break
                    
                default:
                    XCTFail("Unexpected error, was \(error)")
                }
                
            default:
                XCTFail("Result was successful")
            }
            
            failureExpectation.fulfill()
            URLProtocol.unregisterClass(NoDataProtocol.self)
        }
        
        wait(for: [failureExpectation], timeout: 10)
    }
    
    func testGetEmployeesInvalidJSONFails() {
        let failureExpectation = expectation(description: "invalid JSON Failure")
        
        URLProtocol.registerClass(InvalidJSONProtocol.self)
        employeeAPIController.getEmployees { result in
            switch result {
            case .failure(let error):
                switch error {
                case DecodingError.dataCorrupted(_):
                    break
                    
                default:
                    XCTFail("Unexpected error, was \(error)")
                }
                
            default:
                XCTFail("Result was successful")
            }
            
            failureExpectation.fulfill()
            URLProtocol.unregisterClass(InvalidJSONProtocol.self)
        }
        
        wait(for: [failureExpectation], timeout: 10)
    }
    
    func testGetEmployeesWithEmployeesJSONSucceeds() {
        let successExpectation = expectation(description: "get employees success")
        
        URLProtocol.registerClass(ValidJSONProtocol.self)
        employeeAPIController.getEmployees { result in
            switch result {
            case .success(let employees):
                let expectedEmployees = ValidJSONProtocol.makeEmployees().employees
                XCTAssertEqual(employees, expectedEmployees)
            case .failure(let error):
                XCTFail("Failed, error was \(error)")
            }
            
            successExpectation.fulfill()
            URLProtocol.unregisterClass(ValidJSONProtocol.self)
        }
        
        wait(for: [successExpectation], timeout: 10)
    }

}
