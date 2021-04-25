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
    
    func update() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        restaurants = fetchRestaurants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restaurants = fetchRestaurants()
    }
    
    func insertRestaurant(name: String, address: String, city: String, state: String, rating: Float, image: UIImage?, id: String, note: String) -> NSManagedObject {
        let restaurant = NSEntityDescription.insertNewObject(forEntityName:
        "Restaurant", into: self.managedObjectContext)
        restaurant.setValue(name, forKey: "name")
        restaurant.setValue(address, forKey: "address")
        restaurant.setValue(city, forKey: "city")
        restaurant.setValue(state, forKey: "state")
        restaurant.setValue(rating, forKey: "rating")
        restaurant.setValue(image, forKey: "image")
        restaurant.setValue(note, forKey: "note")
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
            let secondVC = segue.destination as! CollectionTableViewController
            secondVC.restaurants = restaurants
        } else if (segue.identifier == "getFood") {
            let secondVC = segue.destination as! CollectionTableViewController
            let foodPlaces = getType(type: "Food")
            secondVC.restaurants = foodPlaces
        } else if (segue.identifier == "getDrink") {
            let secondVC = segue.destination as! CollectionTableViewController
            let drinkPlaces = getType(type: "Drink")
            secondVC.restaurants = drinkPlaces
        } else if (segue.identifier == "getDessert") {
            let secondVC = segue.destination as! CollectionTableViewController
            let dessertPlaces = getType(type: "Dessert")
            secondVC.restaurants = dessertPlaces
        }
    }
    
    // Add the new quote to the list
    @IBAction func unwindFromAddRestaurantView (sender: UIStoryboardSegue) {
        if sender.identifier == "unwindFromAddRestaurantView" {
            let secondVC = sender.source as! AddRestaurantViewController
            if let newName = secondVC.newName {
                var restaurant: NSManagedObject
                let address = secondVC.newAddress
                let city = secondVC.newCity
                let state = secondVC.newState
                let rating = secondVC.newRating
                let note = secondVC.newNote
                
                restaurant = insertRestaurant(name: newName, address: address!, city: city!, state: state!, rating: rating!, image: nil, id: "Default", note: note!)
                restaurants.append(restaurant)
            }
        }
    }
    
    func getType(type: String) -> [NSManagedObject] {
        var tempRestaurant: [NSManagedObject] = []
        
        for restaurant in restaurants {
            if let categories = restaurant.value(forKey: "category") as? [String] {
                if categories.contains(type) {
                    tempRestaurant.append(restaurant)
                }
            }
        }
        return tempRestaurant
    }
}

