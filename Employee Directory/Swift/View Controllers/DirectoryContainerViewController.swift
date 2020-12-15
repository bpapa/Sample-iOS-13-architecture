//
//  DirectoryContainerViewController.swift
//  Employee Directory
//
//  Created by Brian Papa on 6/1/20.
//  Copyright © 2020 Brian Papa. All rights reserved.
//

import UIKit

/// View Controller to display an employee directory. In the case that employees can not be displayed due to error, displays a message
class DirectoryContainerViewController: UIViewController {
    /// Potential states for this view controller.
    private enum DirectoryContainerViewControllerState {
        // The directory is being loaded
        case loading
        // Directory loading failed in Error, specifed by the associated value
        case error(Error)
        // Viewing the list of employees specified in the associated value
        case viewingEmployees([Employee])
    }
    
    // MARK: - outlet properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var messageLabel: UILabel!
    
    // MARK: - private properties
    /// The state reflects the current UI, inspired by https://developer.apple.com/documentation/swift/maintaining_state_in_your_apps
    private var directoryContainerViewControllerState = DirectoryContainerViewControllerState.loading {
        didSet {
            DispatchQueue.main.async {
                self.configureForState()
            }
        }
    }
    /// Controller to interact with API. In a larger program, this could be configured via dependency injection or perhaps be a singleton
    lazy private var employeeAPIController = EmployeeAPIController()
    
    // MARK: - UIViewController methods
    /// Makes a network request for the employees, per the "once per app launch" requirement.
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmployeesFromAPI()
    }

    // MARK: - private methods
    /// Gets a list of employes from API and updates the state on success or failure
    private func getEmployeesFromAPI() {
        employeeAPIController.getEmployees { result in
            switch result {
            case .success(let employees):
                self.directoryContainerViewControllerState = .viewingEmployees(employees)
                
            case .failure(let error):
                self.directoryContainerViewControllerState = .error(error)
            }
        }
    }
    
    /// Updates this view based on changes to the `directoryContainerViewControllerState` property
    private func configureForState() {
        var messageString: String?
        var animateActivityIndicator = false
        
        switch directoryContainerViewControllerState {
        case .viewingEmployees(let employees):
            if employees.count > 0 {
                configureEmployeesTableViewController(with: employees)
            } else {
                messageString = "The machines have come for our jobs, no employees"
            }
            
        case .error(let error):
            messageString = error.localizedDescription
            
        case .loading:
            animateActivityIndicator = true
        }
        
        if let messageString = messageString {
            configureMessageLabel(with: messageString)
        } else {
            messageLabel.isHidden = true
        }
        
        animateActivityIndicator ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    /// Configures a message label to display in the cae that there are no employees available. The label configured in the storyboard is added as a subview of the `view` and is centered
    /// - Parameter text: the text of the message
    private func configureMessageLabel(with text: String) {
        if messageLabel.superview == nil {
            view.addSubview(messageLabel)
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        messageLabel.text = text
    }
    
    /// Configures a `EmployeeTableViewController` with a backing array and adds it as a child view controller
    /// - Parameter employees: an array of `Employees`to display in the table
    private func configureEmployeesTableViewController(with employees: [Employee]) {
        guard let employeesTableViewController = storyboard?.instantiateViewController(identifier: UIStoryboard.employeesTableViewControllerStoryboardID) as? EmployeesTableViewController else { return }
        
        addChild(employeesTableViewController)
        view.insertSubview(employeesTableViewController.view, at: 0)
        employeesTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        employeesTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        employeesTableViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        employeesTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        employeesTableViewController.didMove(toParent: self)
        
        employeesTableViewController.employees = employees
    }
}

