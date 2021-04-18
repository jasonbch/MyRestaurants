//
//  CollectionDetailViewController.swift
//  foodr
//
//  Created by Phong Bach on 4/15/21.
//

import UIKit
import CoreData

class CollectionDetailViewController: UIViewController, UITextFieldDelegate {
    var tappedRestaurant: NSManagedObject?
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantRatingLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    @IBOutlet weak var restaurantStateLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantTextView: UITextView!
    @IBOutlet weak var addNoteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TitleTextField.delegate = self
        //AddressTextField.delegate = self
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let myRestaurant = tappedRestaurant {
            restaurantNameLabel?.text = myRestaurant.value(forKey: "name") as? String
            restaurantAddressLabel?.text = myRestaurant.value(forKey: "address") as? String
            restaurantCityLabel?.text = myRestaurant.value(forKey: "city") as? String
            restaurantStateLabel?.text = myRestaurant.value(forKey: "state") as? String
            restaurantRatingLabel?.text = (myRestaurant.value(forKey: "rating") as? Float)!.description
            restaurantTextView?.text = myRestaurant.value(forKey: "note") as? String
            
            if let imageData = myRestaurant.value(forKey: "image") as? Data {
                let image = UIImage(data:imageData, scale:1.0)
                restaurantImageView?.image = image
            } else {
                restaurantImageView?.image = UIImage(named: "default-image.jpg")
            }
        }
        
        initializeView()
    }
    
    @IBAction func saveNoteTapped(_ sender: UIButton) {
        saveTapped()
    }
    
    // Save the new quotation
    func saveTapped() {
        if let myRestaurant = tappedRestaurant {
            
            let name = myRestaurant.value(forKey: "name") as? String
            let rating = myRestaurant.value(forKey: "rating") as? Float
            let image = myRestaurant.value(forKey: "image") as? Data
            let address = myRestaurant.value(forKey: "address") as? String
            let city = myRestaurant.value(forKey: "city") as? String
            let state = myRestaurant.value(forKey: "state") as? String
            let id = myRestaurant.value(forKey: "id") as? String
            let note = restaurantTextView.text
            
            let newRestaurant = insertRestaurant(name: name,
                             address: address,
                             city: city,
                             state: state,
                             rating: rating,
                             image: image,
                             id: id,
                             note: note)
            // Replace the restaurant
            tappedRestaurant = newRestaurant
            
            // Delete the old restaurant
            deleteRestaurant(myRestaurant)
            
        }
    }
    
    func insertRestaurant(name: String?,
                          address: String?,
                          city: String?,
                          state: String?,
                          rating: Float?,
                          image: Data?,
                          id: String?,
                          note: String?) -> NSManagedObject {
        let restaurant = NSEntityDescription.insertNewObject(forEntityName:
        "Restaurant", into: self.managedObjectContext)
        restaurant.setValue(name, forKey: "name")
        restaurant.setValue(address, forKey: "address")
        restaurant.setValue(rating, forKey: "rating")
        restaurant.setValue(image, forKey: "image")
        restaurant.setValue(id, forKey: "id")
        restaurant.setValue(city, forKey: "city")
        restaurant.setValue(state, forKey: "state")
        restaurant.setValue(note, forKey: "note")
        appDelegate.saveContext() // In AppDelegate.swift
        
        return restaurant
    }
    
    func deleteRestaurant(_ restaurant: NSManagedObject) {
        managedObjectContext.delete(restaurant)
        appDelegate.saveContext()
    }
    
    func initializeView() {	
        restaurantImageView?.contentMode = .scaleAspectFill
        restaurantImageView?.layer.cornerRadius = 10
        restaurantImageView?.layer.masksToBounds = true
        
        addNoteButton.layer.cornerRadius = 4
        addNoteButton.layer.masksToBounds = true
        
        restaurantTextView.layer.cornerRadius = 4
        restaurantTextView.layer.masksToBounds = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Remove keyboard on return
        return false // Do default behavior
    }
}
