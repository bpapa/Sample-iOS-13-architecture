//
//  EmployeesTableViewController.swift
//  Employee Directory
//
//  Created by Brian Papa on 6/1/20.
//  Copyright © 2020 Brian Papa. All rights reserved.
//

import UIKit

/// A View Controller managing a Table View to display a list of employees
class EmployeesTableViewController: UITableViewController {

    // MARK: static constants
    private let cellIdentifier = "employeeCell"
    
    // MARK: public properties
    /// Controller to manage the downloading and caching of images
    lazy var imageDownloadController = ImageDownloadController()
    /// Backing array for the table view. When set, the `tableView` will be reloaded
    var employees: [Employee]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { employees?.count ?? 0 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let employees = employees else {
            fatalError("Employees nil")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EmployeeTableViewCell
        configure(cell: cell, with: employees[indexPath.row], at: indexPath)
        return cell
    }
    
    // MARK: private methods
    /// Configures an `EmployeeTableViewCell`
    /// - Parameters:
    ///   - cell: the cell to configure
    ///   - employee: an employee instance backing this cell
    ///   - indexPath: the index path for the cell in the `tableView`
    private func configure(cell: EmployeeTableViewCell, with employee: Employee, at indexPath: IndexPath) {
        cell.nameLabel.text = employee.fullName
        cell.teamLabel.text = employee.team
        
        configure(imageView: cell.photoImageView, with: employee, at: indexPath)
    }
    
    /// Configures an employee's image view
    /// - Parameters:
    ///   - imageView: the image view to configure
    ///   - employee: the employee instance backing this image
    ///   - indexPath: the index path at which  `imageView` is located in `tableView`
    private func configure(imageView: UIImageView, with employee: Employee, at indexPath: IndexPath) {
        guard let url = employee.photoURLSmall else {
            imageView.image = #imageLiteral(resourceName: "smallPhotoPlaceholder")
            return
        }
        
        imageDownloadController.createCachedImageOrDownload(url: url) { result in
            DispatchQueue.main.async {
                guard let cell = self.tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell else { return }
                
                switch result {
                case .success(let image):
                    cell.photoImageView.image = image
                    
                case .failure(let error):
                    print("error downloading \(url): \(error.localizedDescription)")
                    imageView.image = #imageLiteral(resourceName: "smallPhotoPlaceholder")
                }
            }
        }
    }
}
