//
//  DetailTableViewController.swift
//  foodr
//
//  Created by Phong Bach on 4/6/21.
//

import UIKit
import CoreData

class CollectionTableViewController: UITableViewController {
    var restaurants: [NSManagedObject]?
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "allRestaurantCell", for: indexPath) as! NoteTableViewCell
        
        //cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        // Configure the cell...
        let myRestaurant = restaurants![indexPath.row]
        
        cell.restaurantNameLabel?.text = myRestaurant.value(forKey: "name") as? String
//        cell.restaurantAddressLabel?.text = myRestaurant.value(forKey: "address") as? String
        cell.restaurantCityLabel?.text = "• " + (myRestaurant.value(forKey: "city") as? String)!
//        cell.restaurantStateLabel?.text = myRestaurant.value(forKey: "state") as? String
        cell.restaurantRatingLabel?.text = "• " + (myRestaurant.value(forKey: "rating") as? Float)!.description
        
        if let imageData = myRestaurant.value(forKey: "image") as? Data {
            let image = UIImage(data:imageData,scale:1.0)
            cell.restaurantImageView?.image = image ?? UIImage(named: "default-image.jpg")
        } else {
            cell.restaurantImageView?.image = UIImage(named: "default-image.jpg")
        }
        
        cell.restaurantImageView?.contentMode = .scaleAspectFill
        cell.restaurantImageView?.layer.cornerRadius = 10
        cell.restaurantImageView?.layer.masksToBounds = true

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let restaurant = restaurants![indexPath.row]
            restaurants!.remove(at: indexPath.row)
            deleteRestaurant(restaurant)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "getCollectionDetail") {
            let thirdVC = segue.destination as! CollectionDetailViewController
            let row = self.tableView?.indexPathForSelectedRow?.row ?? 0
            thirdVC.tappedRestaurant = restaurants![row]
        }
    }
    
    // MARK: - Core Data
    func deleteRestaurant(_ restaurant: NSManagedObject) {
        managedObjectContext.delete(restaurant)
        appDelegate.saveContext()
    }
}
