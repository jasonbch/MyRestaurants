//
//  ViewController.swift
//  foodr
//
//  Created by Phong Bach on 4/6/21.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    @IBOutlet weak var addRestaurantButton: UIButton!
    @IBOutlet weak var allRestaurantsButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var dessertButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    
    var restaurants: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addRestaurantButton.layer.masksToBounds = true
        addRestaurantButton.layer.cornerRadius = 0.5 * addRestaurantButton.frame.width
    
        allRestaurantsButton.titleLabel?.text = "All restaurants"
        
        // Initialize CoreData
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        restaurants = fetchRestaurants()
    }
    
    func insertRestaurant(name: String, address: String, rating: Float?, image: UIImage?, id: String) -> NSManagedObject {
        let restaurant = NSEntityDescription.insertNewObject(forEntityName:
        "Restaurant", into: self.managedObjectContext)
        restaurant.setValue(name, forKey: "name")
        restaurant.setValue(address, forKey: "address")
        restaurant.setValue(rating, forKey: "rating")
        restaurant.setValue(image, forKey: "image")
        restaurant.setValue(id, forKey: "id")
        appDelegate.saveContext() // In AppDelegate.swift
        return restaurant
    }
    
    func fetchRestaurants() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        var restaurants: [NSManagedObject] = []
        do {
            restaurants = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getRestaurants error: \(error)")
        }
        return restaurants
    }
    
    func printRestaurant(_ restaurant: NSManagedObject) {
        let name = restaurant.value(forKey: "name") as? String
        let address = restaurant.value(forKey: "address") as? String
        let rating = restaurant.value(forKey: "rating") as? Float
        // let image = restaurant.value(forKey: "image") as? UIImage
        print("Restaurant: name = \(name!), address = \(address!), rating = \(rating!)")
    }
    
    func deleteRestaurant(_ restaurant: NSManagedObject) {
        managedObjectContext.delete(restaurant)
        appDelegate.saveContext()
    }
    
    @IBAction func allRestaurantsButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func foodButtontapped(_ sender: UIButton) {
    }
    
    
    @IBAction func drinkButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func dessertButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
    }
    
    // Prepare to send quote count to Add Quotation View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "getAllRestaurants") {
            let secondVC = segue.destination as! DetailTableViewController
            secondVC.restaurants = restaurants
        }
    }
    
    // Add the new quote to the list
    @IBAction func unwindFromAddRestaurantView (sender: UIStoryboardSegue) {
        if sender.identifier == "unwindFromAddRestaurantView" {
            let secondVC = sender.source as! AddRestaurantViewController
            if let newName = secondVC.newName {
                var restaurant: NSManagedObject
                if let newAddress = secondVC.newAddress{
                    restaurant = insertRestaurant(name: newName, address: newAddress, rating: nil, image: nil, id: "Default")
                } else {
                    restaurant = insertRestaurant(name: newName, address: "No Address", rating: nil, image: nil, id: "Default")
                }
                restaurants.append(restaurant)
                //self.tableView.reloadData()
            }
        }
    }
}

