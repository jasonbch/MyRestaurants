//
//  DetailTableViewController.swift
//  foodr
//
//  Created by Phong Bach on 4/6/21.
//

import UIKit
import CoreData

class DetailTableViewController: UITableViewController {
    var restaurants: [NSManagedObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)

        // Configure the cell...
        let restaurant = restaurants![indexPath.row]
        cell.textLabel?.text = restaurant.value(forKey: "name") as? String
        cell.detailTextLabel?.text = restaurant.value(forKey: "address") as? String

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let restaurant = restaurants![indexPath.row]
            restaurants!.remove(at: indexPath.row)
            //deleteQuotation(quotation)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
