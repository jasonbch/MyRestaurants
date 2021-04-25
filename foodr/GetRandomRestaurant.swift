//
//  ViewController.swift
//  foodr
//
//  Created by Phong Bach on 4/6/21.
//

import UIKit
import CoreData

class GetRandomRestaurant: UIViewController {
    
    var restaurants: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var index = 0
    
    @IBOutlet weak var zimzalabimButton: UIButton!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    @IBOutlet weak var restaurantStateLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var commaLabel: UILabel!
    
    @IBAction func zimzalabimButtonTapped(_ sender: Any) {
        let size = restaurants.count
        let random = Int.random(in: 0..<size)
        let randomRestaurant = restaurants[random]
        restaurantNameLabel.text = randomRestaurant.value(forKey: "name") as? String
        restaurantCityLabel.text = randomRestaurant.value(forKey: "city") as? String
        restaurantStateLabel.text = randomRestaurant.value(forKey: "state") as? String
        inLabel.text = "in"
        commaLabel.text = ","
        titleLabel.text = "The restaurant you should go to is:"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        zimzalabimButton.layer.masksToBounds = true
        zimzalabimButton.layer.cornerRadius = 4
            
        // Initialize CoreData
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        restaurants = fetchRestaurants()
        
        restaurantNameLabel.text = ""
        restaurantCityLabel.text = ""
        restaurantStateLabel.text = ""
        
        titleLabel.text = "Tap the button to get a restaurant!"
        inLabel.text = ""
        commaLabel.text = ""
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
}

